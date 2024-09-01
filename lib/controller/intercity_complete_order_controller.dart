import 'package:customer/constant/constant.dart';
import 'package:customer/model/coupon_model.dart';
import 'package:customer/model/intercity_order_model.dart';
import 'package:get/get.dart';

class IntercityCompleteOrderController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<InterCityOrderModel> orderModel = InterCityOrderModel().obs;
  Rx<CouponModel> selectedCouponModel = CouponModel().obs;
  RxString couponAmount = "0.0".obs;

  double calculateAmount() {
    RxString taxAmount = "0.0".obs;
    if (orderModel.value.taxList != null) {
      for (var element in orderModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant().calculateTax(amount: (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())).toString(), taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(orderModel.value.finalRate.toString()) - double.parse(couponAmount.value.toString())) + double.parse(taxAmount.value);
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];

      if (orderModel.value.coupon != null) {
        if (orderModel.value.coupon?.code != null) {
          if (orderModel.value.coupon!.type == "fix") {
            couponAmount.value = orderModel.value.coupon!.amount.toString();
          } else {
            couponAmount.value = ((double.parse(orderModel.value.finalRate.toString()) * double.parse(orderModel.value.coupon!.amount.toString())) / 100).toString();
          }
        }
      }
    }
    isLoading.value = false;
    update();
  }
}
