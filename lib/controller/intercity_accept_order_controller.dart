import 'package:customer/model/intercity_order_model.dart';
import 'package:get/get.dart';

class InterCityAcceptOrderController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<InterCityOrderModel> orderModel = InterCityOrderModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      orderModel.value = argumentData['orderModel'];
    }
    update();
  }
}
