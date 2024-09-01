import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/model/inbox_model.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/ui/chat_screen/chat_screen.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: Responsive.width(6, context),
            width: Responsive.width(100, context),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: PaginateFirestore(
                  //item builder type is compulsory.
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, documentSnapshots, index) {
                    final data = documentSnapshots[index].data() as Map<String, dynamic>?;
                    InboxModel inboxModel = InboxModel.fromJson(data!);
                    return InkWell(
                      onTap: () async {
                        UserModel? customer = await FireStoreUtils.getUserProfile(inboxModel.customerId.toString());
                        DriverUserModel? driver = await FireStoreUtils.getDriver(inboxModel.driverId.toString());

                        Get.to(ChatScreens(
                          driverId: driver!.id,
                          customerId: customer!.id,
                          customerName: customer.fullName,
                          customerProfileImage: customer.profilePic,
                          driverName: driver.fullName,
                          driverProfileImage: driver.profilePic,
                          orderId: inboxModel.orderId,
                          token: driver.fcmToken,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: ClipOval(
                                child: CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    imageUrl: inboxModel.driverProfileImage.toString(),
                                    imageBuilder: (context, imageProvider) => Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                        ),
                                    errorWidget: (context, url, error) => ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          Constant.userPlaceHolder,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    inboxModel.customerName.toString(),
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                  )),
                                  Text(Constant.dateFormatTimestamp(inboxModel.createdAt), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400)),
                                ],
                              ),
                              subtitle: Text("Ride Id : #${inboxModel.orderId}".tr),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  onEmpty:  Center(child: Text("No Conversion found".tr)),
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance.collection('chat').where("customerId", isEqualTo: FireStoreUtils.getCurrentUid()).orderBy('createdAt', descending: true),
                  //Change types customerId
                  itemBuilderType: PaginateBuilderType.listView,
                  initialLoader: Constant.loader(),
                  // to fetch real-time data
                  isLive: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
