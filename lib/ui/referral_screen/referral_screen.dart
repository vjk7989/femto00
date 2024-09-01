import 'package:clipboard/clipboard.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/referral_controller.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/button_them.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ReferralController>(
        init: ReferralController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: Responsive.width(100, context),
                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/ic_referral_bg.png'), fit: BoxFit.fill)),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Image.asset(
                                'assets/images/referral_image.png',
                                width: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeChange.getThem() ? AppColors.darkInvite : AppColors.background,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Invite Friend & Businesses".tr,
                                  style: GoogleFonts.poppins(color: themeChange.getThem() ? Colors.white : Colors.black),
                                ),
                                Text(
                                  "Earn ${Constant.amountShow(amount: Constant.referralAmount.toString())} each".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: themeChange.getThem() ? Colors.white : Colors.black, fontSize: 22),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Invite Friend & Businesses".tr,
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Invite GoRide to sign up using your link and you’ll get ${Constant.amountShow(amount: Constant.referralAmount.toString())}  ".tr,
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w200),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FlutterClipboard.copy(controller.referralModel.value.referralCode.toString()).then((value) {
                                          ShowToastDialog.showToast("Coupon code copied".tr);
                                        });
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(12),
                                        dashPattern: const [6, 6, 6, 6],
                                        color: AppColors.textFieldBorder,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                controller.referralModel.value.referralCode.toString(),
                                                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                                              )),
                                              Text("Tap to Copy".tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w200))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppColors.darkInvite : AppColors.background,
                                            borderRadius: BorderRadius.circular(40),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: SvgPicture.asset('assets/icons/ic_invite.svg', width: 22, color: themeChange.getThem() ? Colors.white : Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                         Text("Invite a Friend".tr)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppColors.darkInvite : AppColors.background,
                                            borderRadius: BorderRadius.circular(40),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: SvgPicture.asset('assets/icons/ic_register.svg', width: 22, color: themeChange.getThem() ? Colors.white : Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                         Text("They register".tr)
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppColors.darkInvite : AppColors.background,
                                            borderRadius: BorderRadius.circular(40),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: SvgPicture.asset('assets/icons/ic_invite.svg', width: 22, color: themeChange.getThem() ? Colors.white : Colors.black),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                         Text("Get Reward to complete first orde".tr)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ButtonThem.buildButton(
                                context,
                                title: "REFER FRIEND".tr,
                                btnWidthRatio: Responsive.width(100, context),
                                onPress: () async {
                                  ShowToastDialog.showLoader("Please wait".tr);
                                  share(controller);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          );
        });
  }

  Future<void> share(ReferralController controller) async {
    ShowToastDialog.closeLoader();
    await FlutterShare.share(
      title: 'GoRide'.tr,
      text:
      'Hey there, thanks for choosing GoRide. Hope you love our product. If you do, share it with your friends using code ${controller.referralModel.value.referralCode.toString()} and get ${Constant.amountShow(amount: Constant.referralAmount)}.'.tr,
    );
  }
}
