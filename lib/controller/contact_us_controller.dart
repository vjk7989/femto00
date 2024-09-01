import 'package:customer/constant/collection_name.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> feedbackController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getContactUsInformation();
    super.onInit();
  }

  RxString email = "".obs;
  RxString phone = "".obs;
  RxString address = "".obs;
  RxString subject = "".obs;

  getContactUsInformation() async {
    await FireStoreUtils.fireStore.collection(CollectionName.settings).doc("contact_us").get().then((value) {
      if (value.exists) {
        email.value = value.data()!["email"];
        phone.value = value.data()!["phone"];
        address.value = value.data()!["address"];
        subject.value = value.data()!["subject"];
        isLoading.value = false;
      }
    });
  }
}
