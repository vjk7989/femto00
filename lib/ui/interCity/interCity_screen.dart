import 'dart:io';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/interCity_controller.dart';
import 'package:customer/model/contact_model.dart';
import 'package:customer/model/conversation_model.dart';
import 'package:customer/model/freight_vehicle.dart';
import 'package:customer/model/intercity_order_model.dart';
import 'package:customer/model/intercity_service_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/order/positions.dart';
import 'package:customer/model/place_picker_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/themes/text_field_them.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/widget/google_map_search_place.dart';
import 'package:customer/widget/osm_map_search_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InterCityScreen extends StatelessWidget {
  const InterCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<InterCityController>(
      init: InterCityController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: controller.isLoading.value
              ? Constant.loader()
              : Column(
                  children: [
                    SizedBox(
                      height: Responsive.width(4, context),
                      width: Responsive.width(100, context),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (Constant.selectedMapType == 'osm') {
                                          Get.to(const OsmSearchPlacesApi())?.then((value) {
                                            if (value != null) {
                                              SearchInfo place = value;
                                              controller.sourceCityController.value.text = place.address.toString();
                                              controller.sourceLocationController.value.text = place.address.toString();
                                              controller.sourceLocationLAtLng.value = LocationLatLng(latitude: place.point?.latitude, longitude: place.point?.longitude);
                                              controller.calculateOsmAmount();
                                            }
                                          });
                                        } else {
                                          Get.to(const GoogleMapSearchPlacesApi())!.then((value) async {
                                            if (value != null) {
                                              PlaceDetailsModel placeDetailsModel = value;
                                              controller.sourceCityController.value.text = placeDetailsModel.result!.vicinity.toString();

                                              controller.sourceLocationController.value.text = placeDetailsModel.result!.formattedAddress.toString();
                                              controller.sourceLocationLAtLng.value = LocationLatLng(
                                                  latitude: placeDetailsModel.result!.geometry!.location!.lat, longitude: placeDetailsModel.result!.geometry!.location!.lng);

                                              controller.calculateAmount();
                                            }
                                          });
                                        }
                                      },
                                      child: TextFieldThem.buildTextFiled(
                                        context,
                                        hintText: 'From'.tr,
                                        controller: controller.sourceLocationController.value,
                                        enable: false,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (Constant.selectedMapType == 'osm') {
                                          Get.to(const OsmSearchPlacesApi())?.then((value) {
                                            if (value != null) {
                                              SearchInfo place = value;
                                              controller.destinationCityController.value.text = place.address.toString();
                                              controller.destinationLocationController.value.text = place.address.toString();
                                              controller.destinationLocationLAtLng.value = LocationLatLng(latitude: place.point!.latitude, longitude: place.point!.longitude);
                                              controller.calculateOsmAmount();
                                            }
                                          });
                                        } else {
                                          Get.to(const GoogleMapSearchPlacesApi())!.then((value) async {
                                            if (value != null) {
                                              PlaceDetailsModel placeDetailsModel = value;
                                              controller.destinationCityController.value.text = placeDetailsModel.result!.vicinity.toString();

                                              controller.destinationLocationController.value.text = placeDetailsModel.result!.formattedAddress.toString();
                                              controller.destinationLocationLAtLng.value = LocationLatLng(
                                                  latitude: placeDetailsModel.result!.geometry!.location!.lat, longitude: placeDetailsModel.result!.geometry!.location!.lng);

                                              controller.calculateAmount();
                                            }
                                          });
                                        }
                                      },
                                      child: TextFieldThem.buildTextFiled(
                                        context,
                                        hintText: 'To'.tr,
                                        controller: controller.destinationLocationController.value,
                                        enable: false,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text("Select Option".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, letterSpacing: 1)),
                                  const SizedBox(
                                    height: 05,
                                  ),
                                  SizedBox(
                                    height: Responsive.height(18, context),
                                    child: ListView.builder(
                                      itemCount: controller.intercityService.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        IntercityServiceModel serviceModel = controller.intercityService[index];
                                        return Obx(
                                          () => InkWell(
                                            onTap: () {
                                              controller.selectedInterCityType.value = serviceModel;
                                              if (Constant.selectedMapType == 'osm') {
                                                controller.calculateOsmAmount();
                                              } else {
                                                controller.calculateAmount();
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Container(
                                                width: Responsive.width(28, context),
                                                decoration: BoxDecoration(
                                                    color: controller.selectedInterCityType.value == serviceModel
                                                        ? themeChange.getThem()
                                                            ? AppColors.darkModePrimary
                                                            : AppColors.primary
                                                        : themeChange.getThem()
                                                            ? AppColors.darkService
                                                            : controller.colors[index % controller.colors.length],
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(20),
                                                    )),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(20),
                                                          )),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: CachedNetworkImage(
                                                          imageUrl: serviceModel.image.toString(),
                                                          fit: BoxFit.contain,
                                                          height: Responsive.height(8, context),
                                                          width: Responsive.width(18, context),
                                                          placeholder: (context, url) => Constant.loader(),
                                                          errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(serviceModel.name.toString(),
                                                        style: GoogleFonts.poppins(
                                                            color: controller.selectedInterCityType.value == serviceModel
                                                                ? themeChange.getThem()
                                                                    ? Colors.black
                                                                    : Colors.white
                                                                : themeChange.getThem()
                                                                    ? Colors.white
                                                                    : Colors.black)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        BottomPicker.dateTime(
                                          onSubmit: (index) {
                                            controller.dateAndTime = index;
                                            DateFormat dateFormat = DateFormat("EEE dd MMMM , HH:mm aa");
                                            String string = dateFormat.format(index);

                                            controller.whenController.value.text = string;
                                          },
                                          minDateTime: DateTime.now(),
                                          buttonAlignment: MainAxisAlignment.center,
                                          displaySubmitButton: true,
                                          pickerTitle: const Text(''),
                                          buttonSingleColor: AppColors.primary,
                                        ).show(context);
                                      },
                                      child: TextFieldThem.buildTextFiled(
                                        context,
                                        hintText: 'When'.tr,
                                        controller: controller.whenController.value,
                                        enable: false,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  controller.selectedInterCityType.value.id == "647f350983ba2"
                                      ? Column(
                                          children: [
                                            TextFieldThem.buildTextFiled(
                                              context,
                                              hintText: 'Parcel weight (In Kg.)'.tr,
                                              controller: controller.parcelWeight.value,
                                              keyBoardType: TextInputType.number,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFieldThem.buildTextFiled(
                                              context,
                                              hintText: 'Parcel dimension(In ft.)'.tr,
                                              controller: controller.parcelDimension.value,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'^\d{1,6}(?:-\d{0,4})?\*')),
                                              ],
                                            ),
                                            parcelImageWidget(context, controller),
                                          ],
                                        )
                                      : controller.selectedInterCityType.value.id == "Kn2VEnPI3ikF58uK8YqY"
                                          ? Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    vehicleFreightDialog(context, controller);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                      border: Border.all(color: AppColors.textFieldBorder, width: 1),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.fire_truck),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                            controller.selectedFreightVehicle.value.id != null && controller.selectedFreightVehicle.value.id!.isNotEmpty
                                                                ? controller.selectedFreightVehicle.value.name.toString()
                                                                : "Select Freight Vehicle".tr,
                                                            style: GoogleFonts.poppins(),
                                                          )),
                                                          const Icon(Icons.arrow_drop_down_outlined)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                parcelImageWidget(context, controller),
                                                // Row(
                                                //   children: [
                                                //     Expanded(child: Text("Loader needed".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, letterSpacing: 1))),
                                                //     Transform.scale(scale: 1.0,
                                                //       child: Switch(
                                                //         value: controller.loaderNeeded.value,
                                                //         activeColor:AppColors.primary ,
                                                //         onChanged: (bool value1){
                                                //           controller.loaderNeeded.value = value1;
                                                //         },
                                                //       ),
                                                //     )
                                                //   ],
                                                // )
                                              ],
                                            )
                                          : TextFieldThem.buildTextFiled(
                                              context,
                                              hintText: 'Number of Passengers'.tr,
                                              controller: controller.noOfPassengers.value,
                                              keyBoardType: TextInputType.number,
                                            ),
                                  Obx(
                                    () => controller.sourceLocationLAtLng.value.latitude != null && controller.destinationLocationLAtLng.value.latitude != null
                                        ? Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                child: Container(
                                                  decoration: const BoxDecoration(color: AppColors.gray, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      child: Center(
                                                        child: RichText(
                                                          text: TextSpan(
                                                              text: 'Recommended Price ${Constant.amountShow(amount: controller.amount.value)}. Approx time ${controller.duration}'
                                                                  .tr,
                                                              style: GoogleFonts.poppins(color: Colors.black),
                                                              children: [
                                                                TextSpan(
                                                                    text: controller.selectedInterCityType.value.offerRate == true ? '. Enter your rate'.tr : '',
                                                                    style: GoogleFonts.poppins(color: Colors.black))
                                                              ]),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ),
                                  Visibility(
                                    visible: controller.selectedInterCityType.value.offerRate == true,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: TextFieldThem.buildTextFiledWithPrefixIcon(
                                          context,
                                          hintText: "Enter your offer rate".tr,
                                          controller: controller.offerYourRateController.value,
                                          prefix: Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Text(Constant.currencyModel!.symbol.toString()),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldThem.buildTextFiled(
                                    context,
                                    hintText: 'Comments'.tr,
                                    controller: controller.commentsController.value,
                                    keyBoardType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  controller.selectedInterCityType.value.id == "UmQ2bjWTnlwoKqdCIlTr" || controller.selectedInterCityType.value.id == "647f340e35553"
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                someOneTakingDialog(context, controller);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                  border: Border.all(color: AppColors.textFieldBorder, width: 1),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.person),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        controller.selectedTakingRide.value.fullName == "Myself"
                                                            ? "Myself".tr
                                                            : controller.selectedTakingRide.value.fullName.toString(),
                                                        style: GoogleFonts.poppins(),
                                                      )),
                                                      const Icon(Icons.arrow_drop_down_outlined)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  InkWell(
                                    onTap: () {
                                      paymentMethodDialog(context, controller);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                        border: Border.all(color: AppColors.textFieldBorder, width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_payment.svg',
                                              width: 26,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              controller.selectedPaymentMethod.value.isNotEmpty ? controller.selectedPaymentMethod.value : "Select Payment type".tr,
                                              style: GoogleFonts.poppins(),
                                            )),
                                            const Icon(Icons.arrow_drop_down_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ButtonThem.buildButton(
                                    context,
                                    title: controller.selectedInterCityType.value.id == "Kn2VEnPI3ikF58uK8YqY"
                                        ? "Order Freight"
                                        : controller.selectedInterCityType.value.id == "647f350983ba2"
                                            ? "Order Parcel"
                                            : "Ride Placed".tr,
                                    btnWidthRatio: Responsive.width(100, context),
                                    onPress: () async {
                                      bool isPaymentNotCompleted = await FireStoreUtils.paymentStatusCheckIntercity();

                                      if (isPaymentNotCompleted) {
                                        showAlertDialog(context);
                                        // showDialog(context: context, builder: (BuildContext context) => warningDailog());
                                      } else {
                                        for (int i = 0; i < controller.zoneList.length; i++) {
                                          if (Constant.isPointInPolygon(
                                            LatLng(double.parse(controller.sourceLocationLAtLng.value.latitude.toString()),
                                                double.parse(controller.sourceLocationLAtLng.value.longitude.toString())),
                                            controller.zoneList[i].area!,
                                          )) {
                                            controller.selectedZone.value = controller.zoneList[i];
                                            if (controller.selectedInterCityType.value.id == "647f350983ba2") {
                                              if (controller.sourceLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select source location".tr);
                                              } else if (controller.destinationLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select destination location".tr);
                                              } else if (controller.selectedPaymentMethod.value.isEmpty) {
                                                ShowToastDialog.showToast("Please select Payment Method".tr);
                                              } else if (controller.parcelWeight.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please enter parcel weight".tr);
                                              } else if (controller.parcelDimension.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please enter parcel dimension".tr);
                                              } else if (controller.whenController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select date and time".tr);
                                              } else if (controller.selectedInterCityType.value.offerRate == true && controller.offerYourRateController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please Enter offer rate".tr);
                                              } else {
                                                ShowToastDialog.showLoader("Please wait".tr);

                                                List<dynamic> parcelImages = [];
                                                for (var element in controller.images) {
                                                  Url url = await Constant().uploadChatImageToFireStorage(File(element.path));
                                                  parcelImages.add(url.url);
                                                }

                                                InterCityOrderModel intercityOrderModel = InterCityOrderModel();
                                                intercityOrderModel.id = Constant.getUuid();
                                                intercityOrderModel.userId = FireStoreUtils.getCurrentUid();
                                                intercityOrderModel.sourceLocationName = controller.sourceLocationController.value.text;
                                                intercityOrderModel.sourceCity = controller.sourceCityController.value.text;
                                                intercityOrderModel.sourceLocationLAtLng = controller.sourceLocationLAtLng.value;

                                                intercityOrderModel.parcelImage = parcelImages;
                                                intercityOrderModel.parcelWeight = controller.parcelWeight.value.text;
                                                intercityOrderModel.parcelDimension = controller.parcelDimension.value.text;

                                                intercityOrderModel.destinationLocationName = controller.destinationLocationController.value.text;
                                                intercityOrderModel.destinationCity = controller.destinationCityController.value.text;
                                                intercityOrderModel.destinationLocationLAtLng = controller.destinationLocationLAtLng.value;
                                                intercityOrderModel.distance = controller.distance.value;
                                                intercityOrderModel.offerRate = controller.selectedInterCityType.value.offerRate == true
                                                    ? controller.offerYourRateController.value.text
                                                    : controller.amount.value;
                                                intercityOrderModel.intercityServiceId = controller.selectedInterCityType.value.id;
                                                intercityOrderModel.intercityService = controller.selectedInterCityType.value;
                                                GeoFirePoint position = GeoFlutterFire()
                                                    .point(latitude: controller.sourceLocationLAtLng.value.latitude!, longitude: controller.sourceLocationLAtLng.value.longitude!);

                                                intercityOrderModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
                                                intercityOrderModel.createdDate = Timestamp.now();
                                                intercityOrderModel.status = Constant.ridePlaced;
                                                intercityOrderModel.paymentType = controller.selectedPaymentMethod.value;
                                                intercityOrderModel.paymentStatus = false;
                                                intercityOrderModel.whenTime = DateFormat("HH:mm").format(controller.dateAndTime!);
                                                intercityOrderModel.whenDates = DateFormat("dd-MMM-yyyy").format(controller.dateAndTime!);
                                                intercityOrderModel.comments = controller.commentsController.value.text;
                                                intercityOrderModel.otp = Constant.getReferralCode();
                                                intercityOrderModel.taxList = Constant.taxList;
                                                intercityOrderModel.zoneId = controller.selectedZone.value.id;
                                                intercityOrderModel.zone = controller.selectedZone.value;
                                                intercityOrderModel.adminCommission = controller.selectedInterCityType.value.adminCommission!.isEnabled == false
                                                    ? controller.selectedInterCityType.value.adminCommission!
                                                    : Constant.adminCommission;
                                                intercityOrderModel.distanceType = Constant.distanceType;
                                                await FireStoreUtils.setInterCityOrder(intercityOrderModel).then((value) {
                                                  ShowToastDialog.closeLoader();
                                                  if (value == true) {
                                                    ShowToastDialog.showToast("Ride Placed successfully".tr);
                                                    controller.dashboardController.selectedDrawerIndex(3);
                                                  }
                                                });
                                              }
                                            } else if (controller.selectedInterCityType.value.id == "Kn2VEnPI3ikF58uK8YqY") {
                                              if (controller.sourceLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select source location".tr);
                                              } else if (controller.destinationLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select destination location".tr);
                                              } else if (controller.selectedPaymentMethod.value.isEmpty) {
                                                ShowToastDialog.showToast("Please select Payment Method".tr);
                                              } else if (controller.selectedInterCityType.value.offerRate == true && controller.offerYourRateController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please Enter offer rate".tr);
                                              } else if (controller.whenController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select date and time".tr);
                                              } else if (controller.selectedFreightVehicle.value.id == null || controller.selectedFreightVehicle.value.id!.isEmpty) {
                                                ShowToastDialog.showToast("Please select cargo vehicle size.".tr);
                                              } else {
                                                ShowToastDialog.showLoader("Please wait".tr);

                                                List<dynamic> parcelImages = [];
                                                for (var element in controller.images) {
                                                  Url url = await Constant().uploadChatImageToFireStorage(File(element.path));
                                                  parcelImages.add(url.url);
                                                }

                                                InterCityOrderModel intercityOrderModel = InterCityOrderModel();
                                                intercityOrderModel.id = Constant.getUuid();
                                                intercityOrderModel.userId = FireStoreUtils.getCurrentUid();
                                                intercityOrderModel.sourceLocationName = controller.sourceLocationController.value.text;
                                                intercityOrderModel.sourceCity = controller.sourceCityController.value.text;
                                                intercityOrderModel.sourceLocationLAtLng = controller.sourceLocationLAtLng.value;

                                                intercityOrderModel.parcelImage = parcelImages;
                                                intercityOrderModel.parcelWeight = controller.parcelWeight.value.text;
                                                intercityOrderModel.parcelDimension = controller.parcelDimension.value.text;

                                                intercityOrderModel.destinationLocationName = controller.destinationLocationController.value.text;
                                                intercityOrderModel.destinationCity = controller.destinationCityController.value.text;
                                                intercityOrderModel.destinationLocationLAtLng = controller.destinationLocationLAtLng.value;
                                                intercityOrderModel.distance = controller.distance.value;
                                                intercityOrderModel.offerRate = controller.selectedInterCityType.value.offerRate == true
                                                    ? controller.offerYourRateController.value.text
                                                    : controller.amount.value;
                                                intercityOrderModel.intercityServiceId = controller.selectedInterCityType.value.id;
                                                intercityOrderModel.intercityService = controller.selectedInterCityType.value;
                                                GeoFirePoint position = GeoFlutterFire()
                                                    .point(latitude: controller.sourceLocationLAtLng.value.latitude!, longitude: controller.sourceLocationLAtLng.value.longitude!);

                                                intercityOrderModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
                                                intercityOrderModel.createdDate = Timestamp.now();
                                                intercityOrderModel.status = Constant.ridePlaced;
                                                intercityOrderModel.paymentType = controller.selectedPaymentMethod.value;
                                                intercityOrderModel.paymentStatus = false;
                                                intercityOrderModel.whenTime = DateFormat("HH:mm").format(controller.dateAndTime!);
                                                intercityOrderModel.whenDates = DateFormat("dd-MMM-yyyy").format(controller.dateAndTime!);
                                                intercityOrderModel.comments = controller.commentsController.value.text;
                                                intercityOrderModel.otp = Constant.getReferralCode();
                                                intercityOrderModel.taxList = Constant.taxList;
                                                intercityOrderModel.adminCommission = controller.selectedInterCityType.value.adminCommission!.isEnabled == false
                                                    ? controller.selectedInterCityType.value.adminCommission!
                                                    : Constant.adminCommission;
                                                intercityOrderModel.distanceType = Constant.distanceType;
                                                intercityOrderModel.freightVehicle = controller.selectedFreightVehicle.value;
                                                intercityOrderModel.zoneId = controller.selectedZone.value.id;
                                                intercityOrderModel.zone = controller.selectedZone.value;
                                                print(controller.selectedFreightVehicle.value);
                                                await FireStoreUtils.setInterCityOrder(intercityOrderModel).then((value) {
                                                  ShowToastDialog.closeLoader();
                                                  if (value == true) {
                                                    ShowToastDialog.showToast("Ride Placed successfully".tr);
                                                    controller.dashboardController.selectedDrawerIndex(3);
                                                  }
                                                });
                                              }
                                            } else {
                                              if (controller.sourceLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select source location".tr);
                                              } else if (controller.destinationLocationController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select destination location".tr);
                                              } else if (controller.selectedPaymentMethod.value.isEmpty) {
                                                ShowToastDialog.showToast("Please select Payment Method".tr);
                                              } else if (controller.noOfPassengers.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please enter Number of passenger".tr);
                                              } else if (controller.whenController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please select date and time".tr);
                                              } else if (controller.selectedInterCityType.value.offerRate == true && controller.offerYourRateController.value.text.isEmpty) {
                                                ShowToastDialog.showToast("Please Enter offer rate".tr);
                                              } else {
                                                ShowToastDialog.showLoader("Please wait".tr);
                                                InterCityOrderModel intercityOrderModel = InterCityOrderModel();
                                                intercityOrderModel.id = Constant.getUuid();
                                                intercityOrderModel.userId = FireStoreUtils.getCurrentUid();
                                                intercityOrderModel.sourceLocationName = controller.sourceLocationController.value.text;
                                                intercityOrderModel.sourceCity = controller.sourceCityController.value.text;
                                                intercityOrderModel.sourceLocationLAtLng = controller.sourceLocationLAtLng.value;

                                                intercityOrderModel.destinationLocationName = controller.destinationLocationController.value.text;
                                                intercityOrderModel.destinationCity = controller.destinationCityController.value.text;
                                                intercityOrderModel.destinationLocationLAtLng = controller.destinationLocationLAtLng.value;
                                                intercityOrderModel.distance = controller.distance.value;
                                                intercityOrderModel.offerRate = controller.selectedInterCityType.value.offerRate == true
                                                    ? controller.offerYourRateController.value.text
                                                    : controller.amount.value;
                                                intercityOrderModel.intercityServiceId = controller.selectedInterCityType.value.id;
                                                intercityOrderModel.intercityService = controller.selectedInterCityType.value;
                                                GeoFirePoint position = GeoFlutterFire()
                                                    .point(latitude: controller.sourceLocationLAtLng.value.latitude!, longitude: controller.sourceLocationLAtLng.value.longitude!);

                                                intercityOrderModel.position = Positions(geoPoint: position.geoPoint, geohash: position.hash);
                                                intercityOrderModel.createdDate = Timestamp.now();
                                                intercityOrderModel.status = Constant.ridePlaced;
                                                intercityOrderModel.paymentType = controller.selectedPaymentMethod.value;
                                                intercityOrderModel.paymentStatus = false;
                                                intercityOrderModel.whenTime = DateFormat("HH:mm").format(controller.dateAndTime!);
                                                intercityOrderModel.whenDates = DateFormat("dd-MMM-yyyy").format(controller.dateAndTime!);
                                                intercityOrderModel.numberOfPassenger = controller.noOfPassengers.value.text;
                                                intercityOrderModel.comments = controller.commentsController.value.text;
                                                intercityOrderModel.otp = Constant.getReferralCode();
                                                intercityOrderModel.taxList = Constant.taxList;
                                                intercityOrderModel.adminCommission = controller.selectedInterCityType.value.adminCommission!.isEnabled == false
                                                    ? controller.selectedInterCityType.value.adminCommission!
                                                    : Constant.adminCommission;
                                                intercityOrderModel.distanceType = Constant.distanceType;
                                                intercityOrderModel.zoneId = controller.selectedZone.value.id;
                                                intercityOrderModel.zone = controller.selectedZone.value;
                                                if (controller.selectedTakingRide.value.fullName != "Myself") {
                                                  intercityOrderModel.someOneElse = controller.selectedTakingRide.value;
                                                }
                                                await FireStoreUtils.setInterCityOrder(intercityOrderModel).then((value) {
                                                  ShowToastDialog.closeLoader();
                                                  if (value == true) {
                                                    ShowToastDialog.showToast("Ride Placed successfully".tr);
                                                    controller.dashboardController.selectedDrawerIndex(3);
                                                  }
                                                });
                                              }
                                            }
                                            break;
                                          } else {
                                            ShowToastDialog.showToast(
                                                "Services are currently unavailable on the selected location. Please reach out to the administrator for assistance.",
                                                position: EasyLoadingToastPosition.center);
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Get.back();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Warning"),
      content: const Text("You are not able book new ride please complete previous ride payment"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  paymentMethodDialog(BuildContext context, InterCityController controller) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return FractionallySizedBox(
            heightFactor: 0.9,
            child: StatefulBuilder(builder: (context1, setState) {
              return Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.arrow_back_ios)),
                            Expanded(
                                child: Center(
                                    child: Text(
                              "Select Payment Method".tr,
                            ))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Visibility(
                                visible: controller.paymentModel.value.cash!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.cash!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.cash!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: Icon(Icons.money, color: Colors.black),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.cash!.name.toString(),
                                                    style: GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.cash!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.cash!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.wallet!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.wallet!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.wallet!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SvgPicture.asset('assets/icons/ic_wallet.svg', color: AppColors.primary),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.wallet!.name.toString(),
                                                    style: GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.wallet!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.wallet!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.strip!.enable == true,
                                child: Obx(
                                  () => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.selectedPaymentMethod.value = controller.paymentModel.value.strip!.name.toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            border: Border.all(
                                                color: controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name.toString()
                                                    ? themeChange.getThem()
                                                        ? AppColors.darkModePrimary
                                                        : AppColors.primary
                                                    : AppColors.textFieldBorder,
                                                width: 1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 80,
                                                  decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Image.asset('assets/images/stripe.png'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller.paymentModel.value.strip!.name.toString(),
                                                    style: GoogleFonts.poppins(),
                                                  ),
                                                ),
                                                Radio(
                                                  value: controller.paymentModel.value.strip!.name.toString(),
                                                  groupValue: controller.selectedPaymentMethod.value,
                                                  activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                  onChanged: (value) {
                                                    controller.selectedPaymentMethod.value = controller.paymentModel.value.strip!.name.toString();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.paypal!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.paypal!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paypal.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.paypal!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.paypal!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.paypal!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.payStack!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.payStack!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paystack.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.payStack!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.payStack!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.payStack!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.mercadoPago!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.mercadoPago!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/mercadopago.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.mercadoPago!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.mercadoPago!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.mercadoPago!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.flutterWave!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.flutterWave!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/flutterwave.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.flutterWave!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.flutterWave!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.flutterWave!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.payfast!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.payfast!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.payfast!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/payfast.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.payfast!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.payfast!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.payfast!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.paytm!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.paytm!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.paytm!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/paytam.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.paytm!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.paytm!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.paytm!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.razorpay!.enable == true,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.selectedPaymentMethod.value = controller.paymentModel.value.razorpay!.name.toString();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(
                                              color: controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name.toString()
                                                  ? themeChange.getThem()
                                                      ? AppColors.darkModePrimary
                                                      : AppColors.primary
                                                  : AppColors.textFieldBorder,
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 80,
                                                decoration: const BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset('assets/images/razorpay.png'),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.paymentModel.value.razorpay!.name.toString(),
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Radio(
                                                value: controller.paymentModel.value.razorpay!.name.toString(),
                                                groupValue: controller.selectedPaymentMethod.value,
                                                activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                                onChanged: (value) {
                                                  controller.selectedPaymentMethod.value = controller.paymentModel.value.razorpay!.name.toString();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonThem.buildButton(
                        context,
                        title: "Pay".tr,
                        onPress: () async {
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  vehicleFreightDialog(BuildContext context, InterCityController controller) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return StatefulBuilder(builder: (context1, setState) {
            return Obx(
              () => Container(
                constraints: BoxConstraints(maxHeight: Responsive.height(90, context)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "Which vehicle is suitable for your cargo?",
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.close)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          itemCount: controller.frightVehicleList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            FreightVehicle freightModel = controller.frightVehicleList[index];
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedFreightVehicle.value = freightModel;
                                    if (Constant.selectedMapType == 'osm') {
                                      controller.calculateOsmAmount();
                                    } else {
                                      controller.calculateAmount();
                                    }
                                    Get.back();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: controller.selectedFreightVehicle.value.id == freightModel.id
                                              ? themeChange.getThem()
                                                  ? AppColors.darkModePrimary
                                                  : AppColors.primary
                                              : AppColors.textFieldBorder,
                                          width: 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: freightModel.image.toString(),
                                            fit: BoxFit.contain,
                                            height: Responsive.height(6, context),
                                            width: Responsive.width(18, context),
                                            placeholder: (context, url) => Constant.loader(),
                                            errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  freightModel.name.toString(),
                                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  freightModel.description.toString(),
                                                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: themeChange.getThem() ? AppColors.darkGray : AppColors.gray,
                                                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                  child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "📦 len/wid/hgt :",
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            "${freightModel.length}/${freightModel.width}/${freightModel.height}m",
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  someOneTakingDialog(BuildContext context, InterCityController controller) {
    return showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context1) {
          final themeChange = Provider.of<DarkThemeProvider>(context1);

          return StatefulBuilder(builder: (context1, setState) {
            return Obx(
              () => Container(
                constraints: BoxConstraints(maxHeight: Responsive.height(90, context)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Someone else taking this ride?",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Choose a contact and share a code to conform that ride.",
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.selectedTakingRide.value = ContactModel(fullName: "Myself", contactNumber: "");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  color: controller.selectedTakingRide.value.fullName == "Myself"
                                      ? themeChange.getThem()
                                          ? AppColors.darkModePrimary
                                          : AppColors.primary
                                      : AppColors.textFieldBorder,
                                  width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.person, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Myself",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  Radio(
                                    value: "Myself",
                                    groupValue: controller.selectedTakingRide.value.fullName,
                                    activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                    onChanged: (value) {
                                      controller.selectedTakingRide.value = ContactModel(fullName: "Myself", contactNumber: "");
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          itemCount: controller.contactList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ContactModel contactModel = controller.contactList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  controller.selectedTakingRide.value = contactModel;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: controller.selectedTakingRide.value.fullName == contactModel.fullName
                                            ? themeChange.getThem()
                                                ? AppColors.darkModePrimary
                                                : AppColors.primary
                                            : AppColors.textFieldBorder,
                                        width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.person, color: Colors.black),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            contactModel.fullName.toString(),
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        Radio(
                                          value: contactModel.fullName.toString(),
                                          groupValue: controller.selectedTakingRide.value.fullName,
                                          activeColor: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary,
                                          onChanged: (value) {
                                            controller.selectedTakingRide.value = contactModel;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            final FullContact contact = await FlutterContactPicker.pickFullContact();
                            ContactModel contactModel = ContactModel();
                            contactModel.fullName = "${contact.name!.firstName ?? ""} ${contact.name!.middleName ?? ""} ${contact.name!.lastName ?? ""}";
                            contactModel.contactNumber = contact.phones[0].number;

                            if (!controller.contactList.contains(contactModel)) {
                              controller.contactList.add(contactModel);
                              controller.setContact();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.contacts, color: Colors.black),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    "Choose another contact",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonThem.buildButton(
                          context,
                          title: "Book for ${controller.selectedTakingRide.value.fullName}",
                          onPress: () async {
                            Get.back();
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  parcelImageWidget(BuildContext context, InterCityController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      child: SizedBox(
        height: 100,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Obx(
                () => ListView.builder(
                  itemCount: controller.images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 100,
                        height: 100.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover, image: FileImage(File(controller.images[index].path))),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: InkWell(
                            onTap: () {
                              controller.images.removeAt(index);
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              size: 30,
                            )),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    _onCameraClick(context, controller);
                  },
                  child: Image.asset(
                    'assets/images/parcel_add_image.png',
                    height: 100,
                    width: 100,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onCameraClick(BuildContext context, InterCityController controller) {
    final action = CupertinoActionSheet(
      message: Text(
        'Add your parcel image.'.tr,
        style: const TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: false,
          onPressed: () async {
            Get.back();
            await ImagePicker().pickMultiImage().then((value) {
              value.forEach((element) {
                controller.images.add(element);
              });
            });
          },
          child: Text('Choose image from gallery'.tr),
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          onPressed: () async {
            Get.back();
            final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
            if (photo != null) {
              controller.images.add(photo);
            }
          },
          child: Text('Take a picture'.tr),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel'.tr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
