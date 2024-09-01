import 'dart:convert';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/model/place_picker_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GoogleMapSearchPlacesApi extends StatefulWidget {
  const GoogleMapSearchPlacesApi({super.key});

  @override
  GoogleMapSearchPlacesApiState createState() => GoogleMapSearchPlacesApiState();
}

class GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=${Constant.mapAPIKey}&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PlaceDetailsModel?> getLatLang(String placeId) async {
    PlaceDetailsModel? placeDetailsModel;
    try {
      String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?placeid=$placeId&key=${Constant.mapAPIKey}';
      var response = await http.get(Uri.parse(request));
      // if (kDebugMode) {
      //   log(response.body);
      // }
      if (response.statusCode == 200) {
        placeDetailsModel = PlaceDetailsModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
    return placeDetailsModel;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: themeChange.getThem() ? AppColors.lightGray : AppColors.lightGray,
          ),
        ),
        title: Text(
          'Search places Api',
          style: TextStyle(
            color: themeChange.getThem() ? AppColors.lightGray : AppColors.lightGray,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
                validator: (value) => value != null && value.isNotEmpty ? null : 'Required',
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: _controller,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
                decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: themeChange.getThem() ? AppColors.darkTextField : AppColors.textField,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    prefixIcon: const Icon(Icons.map),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: themeChange.getThem() ? AppColors.darkTextFieldBorder : AppColors.textFieldBorder, width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                    hintText: "Search your location here".tr)),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      ShowToastDialog.showLoader("Please wait");
                      await getLatLang(_placeList[index]["place_id"]).then((value) {
                        if (value != null) {
                          ShowToastDialog.closeLoader();
                          Get.back(result: value);
                        }
                      });
                    },
                    child: ListTile(
                      title: Text(_placeList[index]["description"]),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
