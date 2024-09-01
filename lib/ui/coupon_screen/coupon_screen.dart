import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/coupon_controller.dart';
import 'package:customer/model/coupon_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CouponController>(
        init: CouponController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title:  Text('Redeem Coupon'.tr),
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                    )),
              ),
              body: Column(
                children: [
                  Container(
                    height: Responsive.width(10, context),
                    width: Responsive.width(100, context),
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -22),
                      child: Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Offers".tr,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                                  ),
                                  Expanded(
                                    child: FutureBuilder<List<CouponModel>?>(
                                        future: FireStoreUtils().getCoupon(),
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Constant.loader();
                                            case ConnectionState.done:
                                              if (snapshot.hasError) {
                                                return Text(snapshot.error.toString());
                                              } else {
                                                List<CouponModel> couponList = snapshot.data!;
                                                return ListView.builder(
                                                  itemCount: couponList.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    CouponModel couponModel = couponList[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        // controller.selectedCouponModel.value = couponModel;
                                                        // if (couponModel.type == "fix") {
                                                        //   controller.couponAmount.value = couponModel.amount.toString();
                                                        // } else {
                                                        //   controller.couponAmount.value =
                                                        //       ((double.parse(controller.orderModel.value.finalRate.toString()) * double.parse(couponModel.amount.toString())) / 100).toString();
                                                        // }
                                                        // Get.back();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: themeChange.getThem() ? AppColors.darkContainerBackground : AppColors.containerBackground,
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.containerBorder, width: 0.5),
                                                            boxShadow: themeChange.getThem()
                                                                ? null
                                                                : [
                                                                    BoxShadow(
                                                                      color: Colors.grey.withOpacity(0.5),
                                                                      blurRadius: 8,
                                                                      offset: const Offset(0, 2), // changes position of shadow
                                                                    ),
                                                                  ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(color: AppColors.lightGray, borderRadius: BorderRadius.circular(60)),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                                                        child: Text(couponModel.type == "fix"?Constant.amountShow(amount: couponModel.amount):"${couponModel.amount}%"),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          couponModel.title.toString(),
                                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                        ),
                                                                        Text(
                                                                          "Valid till ${Constant.dateFormatTimestamp(couponModel.validity)}".tr,
                                                                          style: GoogleFonts.poppins(),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    FlutterClipboard.copy(couponModel.code.toString()).then((value) {
                                                                      ShowToastDialog.showToast("Coupon code copied".tr);
                                                                    });
                                                                  },
                                                                  child: DottedBorder(
                                                                    borderType: BorderType.RRect,
                                                                    radius: const Radius.circular(10),
                                                                    dashPattern: const [6, 6, 6, 6],
                                                                    color: AppColors.textFieldBorder,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                        children: [
                                                                          SvgPicture.asset('assets/icons/ic_offer_image.svg',
                                                                              width: Responsive.width(5, context), height: Responsive.width(5, context)),
                                                                          const SizedBox(width: 10,),
                                                                          Expanded(
                                                                            child: Text(
                                                                              couponModel.code.toString(),
                                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                           Text("Tap to Copy".tr)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            default:
                                              return  Text('Error'.tr);
                                          }
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [6, 6, 6, 6],
                                    color: AppColors.textFieldBorder,
                                    child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: TextFormField(
                                          controller: controller.couponController.value,
                                          textAlign: TextAlign.center,
                                          decoration:  InputDecoration(hintText: "Write coupon code".tr, border: InputBorder.none),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ButtonThem.buildButton(
                                    context,
                                    title: "Apply".tr,
                                    btnWidthRatio: Responsive.width(100, context),
                                    onPress: () async {
                                      if (controller.couponController.value.text.isNotEmpty) {
                                        ShowToastDialog.showLoader("Please wait".tr);
                                        await FireStoreUtils.fireStore.collection(CollectionName.coupon).where('code', isEqualTo: controller.couponController.value.text).where('enable', isEqualTo: true).where('validity',isGreaterThanOrEqualTo: Timestamp.now()).get().then((value) {
                                          ShowToastDialog.closeLoader();
                                          if (value.docs.isNotEmpty) {
                                            CouponModel couponModel = CouponModel.fromJson(value.docs.first.data());
                                            Get.back(result: couponModel);
                                          }else{
                                            ShowToastDialog.showToast("Coupon code is Invalid".tr);
                                          }
                                        }).catchError((error) {
                                          log(error.toString());
                                        });
                                      } else {
                                        ShowToastDialog.showToast("Please Enter coupon code".tr);
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
                  ),
                ],
              ));
        });
  }
}
