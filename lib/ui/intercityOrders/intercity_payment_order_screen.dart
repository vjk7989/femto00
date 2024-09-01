import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/intercity_payment_order_controller.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/model/intercity_order_model.dart';
import 'package:customer/model/tax_model.dart';
import 'package:customer/model/wallet_transaction_model.dart';
import 'package:customer/payment/createRazorPayOrderModel.dart';
import 'package:customer/payment/rozorpayConroller.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/ui/coupon_screen/coupon_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/widget/driver_view.dart';
import 'package:customer/widget/location_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../themes/button_them.dart';

class InterCityPaymentOrderScreen extends StatelessWidget {
  const InterCityPaymentOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<IntercityPaymentOrderController>(
        init: IntercityPaymentOrderController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: AppColors.primary,
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                title:  Text("OutStation ride details".tr),
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
                  SizedBox(
                    height: Responsive.width(8, context),
                    width: Responsive.width(100, context),
                  ),
                  Expanded(
                    child: controller.isLoading.value
                        ? Constant.loader()
                        : Container(
                            decoration:
                                BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection(CollectionName.ordersIntercity).doc(controller.orderModel.value.id).snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Something went wrong'.tr));
                                    }

                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Constant.loader();
                                    }
                                    InterCityOrderModel orderModel = InterCityOrderModel.fromJson(snapshot.data!.data()!);

                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DriverView(driverId: controller.orderModel.value.driverId.toString(), amount: controller.orderModel.value.finalRate.toString()),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 5),
                                              child: Divider(thickness: 1),
                                            ),
                                            Text(
                                              "Vehicle Details".tr,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder<DriverUserModel?>(
                                                future: FireStoreUtils.getDriver(controller.orderModel.value.driverId.toString()),
                                                builder: (context, snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.waiting:
                                                      return Constant.loader();
                                                    case ConnectionState.done:
                                                      if (snapshot.hasError) {
                                                        return Text(snapshot.error.toString());
                                                      } else {
                                                        DriverUserModel driverModel = snapshot.data!;
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: themeChange.getThem() ? AppColors.darkContainerBackground : AppColors.containerBackground,
                                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                            border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.containerBorder, width: 0.5),
                                                            boxShadow: themeChange.getThem()
                                                                ? null
                                                                : [
                                                                    BoxShadow(
                                                                      color: Colors.black.withOpacity(0.10),
                                                                      blurRadius: 5,
                                                                      offset: const Offset(0, 4), // changes position of shadow
                                                                    ),
                                                                  ],
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      'assets/icons/ic_car.svg',
                                                                      width: 18,
                                                                      color: themeChange.getThem() ? Colors.white : Colors.black,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      driverModel.vehicleInformation!.vehicleType.toString(),
                                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      'assets/icons/ic_color.svg',
                                                                      width: 18,
                                                                      color: themeChange.getThem() ? Colors.white : Colors.black,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      driverModel.vehicleInformation!.vehicleColor.toString(),
                                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/icons/ic_number.png',
                                                                      width: 18,
                                                                      color: themeChange.getThem() ? Colors.white : Colors.black,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      driverModel.vehicleInformation!.vehicleNumber.toString(),
                                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    default:
                                                      return  Text('Error'.tr);
                                                  }
                                                }),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Pickup and drop-off locations".tr,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: themeChange.getThem() ? AppColors.darkContainerBackground : AppColors.containerBackground,
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.containerBorder, width: 0.5),
                                                boxShadow: themeChange.getThem()
                                                    ? null
                                                    : [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.10),
                                                          blurRadius: 5,
                                                          offset: const Offset(0, 4), // changes position of shadow
                                                        ),
                                                      ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: LocationView(
                                                  sourceLocation: controller.orderModel.value.sourceLocationName.toString(),
                                                  destinationLocation: controller.orderModel.value.destinationLocationName.toString(),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: Container(
                                                decoration:
                                                    BoxDecoration(color: themeChange.getThem() ? AppColors.darkGray : AppColors.gray, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          Expanded(child: Text(orderModel.status.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w500))),
                                                          Text(Constant().formatTimestamp(orderModel.createdDate), style: GoogleFonts.poppins()),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: themeChange.getThem() ? AppColors.darkContainerBackground : AppColors.containerBackground,
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.containerBorder, width: 0.5),
                                                boxShadow: themeChange.getThem()
                                                    ? null
                                                    : [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.10),
                                                          blurRadius: 5,
                                                          offset: const Offset(0, 4), // changes position of shadow
                                                        ),
                                                      ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(const CouponScreen())!.then((value) {
                                                      if (value != null) {
                                                        controller.selectedCouponModel.value = value;
                                                        if (controller.selectedCouponModel.value.type == "fix") {
                                                          controller.couponAmount.value =
                                                              double.parse(controller.selectedCouponModel.value.amount.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                                                        } else {
                                                          controller.couponAmount.value =
                                                              ((double.parse(controller.selectedCouponModel.value.amount.toString()) * double.parse(controller.orderModel.value.finalRate.toString())) /
                                                                      100)
                                                                  .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/icons/ic_offer.png',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Redeem Coupon".tr,
                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                                                            ),
                                                            Text(
                                                              "Add coupon code".tr,
                                                              style: GoogleFonts.poppins(),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_add_offer.svg",
                                                        width: 40,
                                                        height: 40,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: themeChange.getThem() ? AppColors.darkContainerBackground : AppColors.containerBackground,
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                border: Border.all(color: themeChange.getThem() ? AppColors.darkContainerBorder : AppColors.containerBorder, width: 0.5),
                                                boxShadow: themeChange.getThem()
                                                    ? null
                                                    : [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.10),
                                                          blurRadius: 5,
                                                          offset: const Offset(0, 4), // changes position of shadow
                                                        ),
                                                      ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Booking summary".tr,
                                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Ride Amount".tr,
                                                            style: GoogleFonts.poppins(color: AppColors.subTitleColor),
                                                          ),
                                                        ),
                                                        Text(
                                                          Constant.amountShow(amount: controller.orderModel.value.finalRate.toString()),
                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                    controller.orderModel.value.taxList == null
                                                        ? const SizedBox()
                                                        : ListView.builder(
                                                            itemCount: controller.orderModel.value.taxList!.length,
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets.zero,
                                                            itemBuilder: (context, index) {
                                                              TaxModel taxModel = controller.orderModel.value.taxList![index];
                                                              return Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Text(
                                                                          "${taxModel.title.toString()} (${taxModel.type == "fix" ? Constant.amountShow(amount: taxModel.tax) : "${taxModel.tax}%"})",
                                                                          style: GoogleFonts.poppins(color: AppColors.subTitleColor),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        Constant.amountShow(
                                                                            amount: Constant()
                                                                                .calculateTax(
                                                                                    amount: (double.parse(controller.orderModel.value.finalRate.toString()) -
                                                                                            double.parse(controller.couponAmount.value.toString()))
                                                                                        .toString(),
                                                                                    taxModel: taxModel)
                                                                                .toString()),
                                                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    thickness: 1,
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Discount".tr,
                                                            style: GoogleFonts.poppins(color: AppColors.subTitleColor),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "(-${controller.couponAmount.value == "0.0" ? Constant.amountShow(amount: "0.0") : Constant.amountShow(amount: controller.couponAmount.value)})",
                                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.red),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Payable amount".tr,
                                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                          ),
                                                        ),
                                                        Text(
                                                          Constant.amountShow(amount: controller.calculateAmount().toString()),
                                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ButtonThem.buildButton(
                                              context,
                                              title: "Pay".tr,
                                              onPress: () {
                                                paymentMethodDialog(context, controller, orderModel);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                  ),
                ],
              ));
        });
  }

  paymentMethodDialog(BuildContext context, IntercityPaymentOrderController controller, InterCityOrderModel orderModel) {
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
                              style: GoogleFonts.poppins(),
                            ))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                                  Text("(${Constant.amountShow(amount: controller.userModel.value.walletAmount.toString())})",
                                                      style: GoogleFonts.poppins(color: themeChange.getThem() ? AppColors.darkModePrimary : AppColors.primary)),
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonThem.buildButton(
                        context,
                        title: "Pay".tr,
                        onPress: () async {
                          Get.back();
                          if (controller.selectedPaymentMethod.value == controller.paymentModel.value.strip!.name) {
                            controller.stripeMakePayment(amount: controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paypal!.name) {
                            controller.paypalPaymentSheet(controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payStack!.name) {
                            controller.payStackPayment(controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.mercadoPago!.name) {
                            controller.mercadoPagoMakePayment(context: context, amount: controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.flutterWave!.name) {
                            controller.flutterWaveInitiatePayment(context: context, amount: controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.payfast!.name) {
                            controller.payFastPayment(context: context, amount: controller.calculateAmount().toStringAsFixed(Constant.currencyModel!.decimalDigits!));
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.paytm!.name) {
                            controller.getPaytmCheckSum(context, amount: controller.calculateAmount());
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.razorpay!.name) {
                            RazorPayController().createOrderRazorPay(amount: controller.calculateAmount().toInt(), razorpayModel: controller.paymentModel.value.razorpay).then((value) {
                              if (value == null) {
                                Get.back();
                                ShowToastDialog.showToast("Something went wrong, please contact admin.".tr);
                              } else {
                                CreateRazorPayOrderModel result = value;
                                controller.openCheckout(amount: controller.calculateAmount().toInt(), orderId: result.id);
                              }
                            });
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.wallet!.name) {
                            if (double.parse(controller.userModel.value.walletAmount.toString()) >= controller.calculateAmount()) {
                              WalletTransactionModel transactionModel = WalletTransactionModel(
                                  id: Constant.getUuid(),
                                  amount: "-${controller.calculateAmount().toString()}",
                                  createdDate: Timestamp.now(),
                                  paymentType: orderModel.paymentType,
                                  transactionId: orderModel.id,
                                  note: "Ride amount debit".tr,
                                  orderType: "intercity",
                                  userType: "customer",
                                  userId: FireStoreUtils.getCurrentUid());

                              await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
                                if (value == true) {
                                  await FireStoreUtils.updateUserWallet(amount: "-${controller.calculateAmount().toString()}").then((value) {
                                    Get.back();
                                    controller.completeOrder();
                                  });
                                }
                              });
                            } else {
                              ShowToastDialog.showToast("Wallet Amount Insufficient".tr);
                            }
                          } else if (controller.selectedPaymentMethod.value == controller.paymentModel.value.cash!.name) {
                            controller.completeCashOrder();
                          }
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
}
