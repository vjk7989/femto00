import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controller/on_boarding_controller.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/ui/auth_screen/login_screen.dart';
import 'package:customer/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<OnBoardingController>(
      init: OnBoardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: controller.isLoading.value
              ? Constant.loader()
              : Stack(
                  children: [
                    controller.selectedPageIndex.value == 0
                        ? Image.asset("assets/images/onboarding_1.png")
                        : controller.selectedPageIndex.value == 1
                            ? Image.asset("assets/images/onboarding_2.png")
                            : Image.asset("assets/images/onboarding_3.png"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.selectedPageIndex,
                              itemCount: controller.onBoardingList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 90,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(60),
                                        child: CachedNetworkImage(
                                          imageUrl: controller.onBoardingList[index].image.toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Constant.loader(),
                                          errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            controller.onBoardingList[index].title.toString(),
                                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Text(
                                              controller.onBoardingList[index].description.toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, letterSpacing: 1.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  controller.pageController.jumpToPage(2);
                                },
                                child: Text(
                                  'skip'.tr,
                                  style: const TextStyle(fontSize: 16, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controller.onBoardingList.length,
                                  (index) => Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: controller.selectedPageIndex.value == index ? 30 : 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: controller.selectedPageIndex.value == index ? AppColors.primary : const Color(0xffD4D5E0),
                                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                      )),
                                ),
                              ),
                            ),
                            ButtonThem.buildButton(
                              context,
                              title: controller.selectedPageIndex.value == 2 ? 'Get started'.tr : 'Next'.tr,
                              btnRadius: 30,
                              onPress: () {
                                if (controller.selectedPageIndex.value == 2) {
                                  Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                  Get.offAll(const LoginScreen());
                                } else {
                                  controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ))
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }

// BorderRadiusGeometry borderRadius(int index, int currentIndex) {
//   if (index == 0 && currentIndex == 0) {
//     return const BorderRadius.all(Radius.circular(10.0));
//   }
//   if (index == 0 && currentIndex == 1) {
//     return const BorderRadius.only(topLeft: Radius.circular(40.0), bottomLeft: Radius.circular(40.0));
//   }
//   if (index == 0 && currentIndex == 2) {
//     return const BorderRadius.only(topRight: Radius.circular(40.0), bottomRight: Radius.circular(40.0));
//   }
//   if (index == 1 && currentIndex == 1) {
//     return const BorderRadius.all(Radius.circular(10.0));
//   }
//   if (index == 1 && currentIndex == 1) {
//     return const BorderRadius.all(Radius.circular(10.0));
//   }
//   if (index == 1 && currentIndex == 2) {
//     return const BorderRadius.all(Radius.circular(10.0));
//   }
//   if (index == 2 && currentIndex == 2) {
//     return const BorderRadius.all(Radius.circular(10.0));
//   }
//   if (index == 2 && currentIndex == 0) {
//     return const BorderRadius.only(topLeft: Radius.circular(40.0), bottomLeft: Radius.circular(40.0));
//   }
//   if (index == 2 && currentIndex == 1) {
//     return const BorderRadius.only(topRight: Radius.circular(40.0), bottomRight: Radius.circular(40.0));
//   }
//   return const BorderRadius.all(Radius.circular(10.0));
// }
}
