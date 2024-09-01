import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/rating_controller.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/text_field_them.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/widget/my_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<RatingController>(
        init: RatingController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title:  Text("Review".tr),
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                  )),
            ),
            backgroundColor: themeChange.getThem() ? AppColors.darkBackground : AppColors.primary,
            body: controller.isLoading.value == true
                ? Constant.loader()
                : Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 42, bottom: 20),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 80,
                                  ),
                                  Text(
                                    '${controller.driverModel.value.fullName}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(letterSpacing: 0.8, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 22,
                                        color: AppColors.ratingColour,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(Constant.calculateReview(reviewCount: controller.driverModel.value.reviewsCount.toString(), reviewSum: controller.driverModel.value.reviewsSum.toString()),
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${controller.driverModel.value.vehicleInformation!.vehicleNumber}", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${controller.driverModel.value.vehicleInformation!.vehicleType}", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${controller.driverModel.value.vehicleInformation!.vehicleColor}", style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const MySeparator(color: Colors.grey),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Rate for'.tr,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(letterSpacing: 0.8),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      "${controller.driverModel.value.fullName}",
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, letterSpacing: 2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: RatingBar.builder(
                                      initialRating: controller.rating.value,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        controller.rating(rating);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: TextFieldThem.buildTextFiled(context, hintText: 'Comment..'.tr, controller: controller.commentController.value, maxLine: 5),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ButtonThem.buildButton(
                                    context,
                                    title: "Submit".tr,
                                    onPress: () async {
                                      ShowToastDialog.showLoader("Please wait".tr);

                                      await FireStoreUtils.getDriver(
                                              controller.type.value == "orderModel" ? controller.orderModel.value.driverId.toString() : controller.intercityOrderModel.value.driverId.toString())
                                          .then((value) async {
                                        if (value != null) {
                                          DriverUserModel driverUserModel = value;

                                          if (controller.reviewModel.value.id != null) {
                                            driverUserModel.reviewsSum =
                                                (double.parse(driverUserModel.reviewsSum.toString()) - double.parse(controller.reviewModel.value.rating.toString())).toString();
                                            driverUserModel.reviewsCount = (double.parse(driverUserModel.reviewsCount.toString()) - 1).toString();
                                          }
                                          driverUserModel.reviewsSum = (double.parse(driverUserModel.reviewsSum.toString()) + double.parse(controller.rating.value.toString())).toString();
                                          driverUserModel.reviewsCount = (double.parse(driverUserModel.reviewsCount.toString()) + 1).toString();
                                          await FireStoreUtils.updateDriver(driverUserModel);
                                        }
                                      });

                                      controller.reviewModel.value.id = controller.type.value == "orderModel" ? controller.orderModel.value.id : controller.intercityOrderModel.value.id;
                                      controller.reviewModel.value.comment = controller.commentController.value.text;
                                      controller.reviewModel.value.rating = controller.rating.value.toString();
                                      controller.reviewModel.value.customerId = FireStoreUtils.getCurrentUid();
                                      controller.reviewModel.value.driverId =
                                          controller.type.value == "orderModel" ? controller.orderModel.value.driverId : controller.intercityOrderModel.value.driverId;
                                      controller.reviewModel.value.date = Timestamp.now();
                                      controller.reviewModel.value.type = controller.type.value == "orderModel" ? "city" : "intercity";

                                      await FireStoreUtils.setReview(controller.reviewModel.value).then((value) {
                                        if (value != null && value == true) {
                                          ShowToastDialog.closeLoader();
                                          ShowToastDialog.showToast("Review submit successfully".tr);
                                          Get.back();
                                        }
                                      });
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
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 5,
                                    offset: const Offset(0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: controller.driverModel.value.profilePic.toString(),
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Constant.loader(),
                                  errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
