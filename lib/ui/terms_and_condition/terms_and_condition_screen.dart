import 'package:customer/constant/constant.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/responsive.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class TermsAndConditionScreen extends StatelessWidget {
  final String? type;
  const TermsAndConditionScreen({super.key,this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        elevation: 0,
        title: Text(type == "privacy" ? "Privacy Policy".tr : "Terms and Conditions".tr),
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
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Html(
                    shrinkWrap: true,
                    data: type == "privacy"?Constant.privacyPolicy:Constant.termsAndConditions,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
