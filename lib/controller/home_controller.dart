import 'dart:convert';

import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/dash_board_controller.dart';
import 'package:customer/model/airport_model.dart';
import 'package:customer/model/banner_model.dart';
import 'package:customer/model/contact_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/payment_model.dart';
import 'package:customer/model/service_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/model/zone_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:customer/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class HomeController extends GetxController {
  DashBoardController dashboardController = Get.put(DashBoardController());

  Rx<TextEditingController> sourceLocationController = TextEditingController().obs;
  Rx<TextEditingController> destinationLocationController = TextEditingController().obs;
  Rx<TextEditingController> offerYourRateController = TextEditingController().obs;
  Rx<ServiceModel> selectedType = ServiceModel().obs;

  Rx<LocationLatLng> sourceLocationLAtLng = LocationLatLng().obs;
  Rx<LocationLatLng> destinationLocationLAtLng = LocationLatLng().obs;

  RxString currentLocation = "".obs;
  RxBool isLoading = true.obs;
  RxList serviceList = <ServiceModel>[].obs;
  RxList bannerList = <BannerModel>[].obs;
  RxList zoneList = <ZoneModel>[].obs;
  Rx<ZoneModel> selectedZone = ZoneModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  final PageController pageController = PageController(viewportFraction: 0.96, keepPage: true);

  var colors = [
    AppColors.serviceColor1,
    AppColors.serviceColor2,
    AppColors.serviceColor3,
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    getServiceType();
    getPaymentData();
    getContact();
    super.onInit();
  }

  getServiceType() async {
    await FireStoreUtils.getService().then((value) {
      serviceList.value = value;
      if (serviceList.isNotEmpty) {
        selectedType.value = serviceList.first;
      }
    });

    await FireStoreUtils.getBanner().then((value) {
      bannerList.value = value;
    });

    try {
      Constant.currentLocation = await Utils.getCurrentLocation();

      if (Constant.currentLocation != null) {
        if (Constant.selectedMapType == 'google') {
          List<Placemark> placeMarks = await placemarkFromCoordinates(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
          print("=====>");
          print(placeMarks.first);
          Constant.country = placeMarks.first.country;
          Constant.city = placeMarks.first.locality;
          currentLocation.value =
              "${placeMarks.first.name}, ${placeMarks.first.subLocality}, ${placeMarks.first.locality}, ${placeMarks.first.administrativeArea}, ${placeMarks.first.postalCode}, ${placeMarks.first.country}";
        } else {
          Place place = await Nominatim.reverseSearch(
            lat: Constant.currentLocation!.latitude,
            lon: Constant.currentLocation!.longitude,
            zoom: 14,
            addressDetails: true,
            extraTags: true,
            nameDetails: true,
          );
          currentLocation.value = place.displayName.toString();
          Constant.country = place.address?['country'] ?? '';
          Constant.city = place.address?['city'] ?? '';
        }
        await FireStoreUtils().getTaxList().then((value) {
          if (value != null) {
            Constant.taxList = value;
          }
        });

        await FireStoreUtils().getAirports().then((value) {
          if (value != null) {
            Constant.airaPortList = value;
            print("====>");
            print(Constant.airaPortList!.length);
          }
        });
      }
    } catch (e) {
      print("=====>");
      print(e.toString());
      ShowToastDialog.showToast(
          "Location access permission is currently unavailable. You're unable to retrieve any location data. Please grant permission from your device settings.",
          position: EasyLoadingToastPosition.center,
          duration: const Duration(seconds: 3));
    }

    String token = await NotificationService.getToken();
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      userModel.value = value!;
      userModel.value.fcmToken = token;
      FireStoreUtils.updateUser(userModel.value);
    });

    isLoading.value = false;
  }

  RxString duration = "".obs;
  RxString distance = "".obs;
  RxString amount = "".obs;

  calculateAmount() async {
    if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
      await Constant.getDurationDistance(LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!),
              LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
          .then((value) {
        if (value != null) {
          duration.value = value.rows!.first.elements!.first.duration!.text.toString();
          print("duration :: 00 :: ${duration.value}");
          if (Constant.distanceType == "Km") {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1000).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          } else {
            distance.value = (value.rows!.first.elements!.first.distance!.value!.toInt() / 1609.34).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          }
        }
      });
    }
  }

  calculateOsmAmount() async {
    if (sourceLocationLAtLng.value.latitude != null && destinationLocationLAtLng.value.latitude != null) {
      await Constant.getDurationOsmDistance(LatLng(sourceLocationLAtLng.value.latitude!, sourceLocationLAtLng.value.longitude!),
              LatLng(destinationLocationLAtLng.value.latitude!, destinationLocationLAtLng.value.longitude!))
          .then((value) {
        if (value != {} && value.isNotEmpty) {
          int hours = value['routes'].first['duration'] ~/ 3600;
          int minutes = ((value['routes'].first['duration'] % 3600) / 60).round();
          duration.value = '$hours hours $minutes minutes';
          if (Constant.distanceType == "Km") {
            distance.value = (value['routes'].first['distance'] / 1000).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          } else {
            distance.value = (value['routes'].first['distance'] / 1609.34).toString();
            amount.value = Constant.amountCalculate(selectedType.value.kmCharge.toString(), distance.value).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
          }
        }
      });
    }
  }

  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  RxString selectedPaymentMethod = "".obs;

  RxList airPortList = <AriPortModel>[].obs;

  getPaymentData() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });

    await FireStoreUtils().getZone().then((value) {
      if (value != null) {
        zoneList.value = value;
      }
    });
  }

  RxList<ContactModel> contactList = <ContactModel>[].obs;
  Rx<ContactModel> selectedTakingRide = ContactModel(fullName: "Myself", contactNumber: "").obs;
  Rx<AriPortModel> selectedAirPort = AriPortModel().obs;

  setContact() {
    print(jsonEncode(contactList));
    Preferences.setString(Preferences.contactList, json.encode(contactList.map<Map<String, dynamic>>((music) => music.toJson()).toList()));
    getContact();
  }

  getContact() {
    String contactListJson = Preferences.getString(Preferences.contactList);

    if (contactListJson.isNotEmpty) {
      print("---->");
      contactList.clear();
      contactList.value = (json.decode(contactListJson) as List<dynamic>).map<ContactModel>((item) => ContactModel.fromJson(item)).toList();
    }
  }
}
