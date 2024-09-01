import 'package:customer/constant/constant.dart';
import 'package:customer/model/language_model.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getLanguage();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  RxList<String> modeList = <String>['Light mode', 'Dark mode', 'System'].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  Rx<String> selectedMode = "".obs;

  getLanguage() async {
    await FireStoreUtils.getLanguage().then((value) {
      if (value != null) {
        languageList.value = value;
        if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
          LanguageModel pref = Constant.getLanguage();

          for (var element in languageList) {
            if (element.id == pref.id) {
              selectedLanguage.value = element;
            }
          }
        }
      }
    });
    if (Preferences.getString(Preferences.themKey).toString().isNotEmpty) {
      selectedMode.value = Preferences.getString(Preferences.themKey).toString();
    }
    isLoading.value = false;
    update();
  }
}
