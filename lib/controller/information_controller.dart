import 'dart:developer';

import 'package:customer/constant/constant.dart';
import 'package:customer/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;
  RxString countryCode = "+1".obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.value.text = userModel.value.phoneNumber.toString();
        countryCode.value = userModel.value.countryCode.toString();
      } else {
        emailController.value.text = userModel.value.email.toString();
        fullNameController.value.text = userModel.value.fullName.toString();
      }
      log("------->${loginType.value}");
    }
    update();
  }
}
