import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/controller/dash_board_controller.dart';
import 'package:customer/model/user_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/DarkThemeProvider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DashBoardController>(
        init: DashBoardController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: controller.selectedDrawerIndex.value != 0 && controller.selectedDrawerIndex.value != 6
                  ? Text(
                      controller.drawerItems[controller.selectedDrawerIndex.value].title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  : const Text(""),
              leading: Builder(builder: (context) {
                return InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
                    child: SvgPicture.asset('assets/icons/ic_humber.svg'),
                  ),
                );
              }),
              actions: [
                controller.selectedDrawerIndex.value == 0
                    ? FutureBuilder<UserModel?>(
                        future: FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Constant.loader();
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              } else {
                                UserModel driverModel = snapshot.data!;
                                return InkWell(
                                  onTap: () {
                                    controller.selectedDrawerIndex(8);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: driverModel.profilePic.toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Constant.loader(),
                                        errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            default:
                              return  Text('Error'.tr);
                          }
                        })
                    : Container(),
              ],
            ),
            drawer: buildAppDrawer(context, controller),
            body: WillPopScope(onWillPop: controller.onWillPop, child:controller.getDrawerItemWidget(controller.selectedDrawerIndex.value)),
          );
        });
  }

  buildAppDrawer(BuildContext context, DashBoardController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    var drawerOptions = <Widget>[];
    for (var i = 0; i < controller.drawerItems.length; i++) {
      var d = controller.drawerItems[i];
      drawerOptions.add(InkWell(
        onTap: () {
          controller.onSelectItem(i);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:
                BoxDecoration(color: i == controller.selectedDrawerIndex.value ? Theme.of(context).colorScheme.primary : Colors.transparent, borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SvgPicture.asset(
                  d.icon,
                  width: 20,
                  color: i == controller.selectedDrawerIndex.value
                      ? themeChange.getThem()
                          ? Colors.black
                          : Colors.white
                      : themeChange.getThem()
                          ? Colors.white
                          : AppColors.drawerIcon,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  d.title,
                  style: GoogleFonts.poppins(
                      color: i == controller.selectedDrawerIndex.value
                          ? themeChange.getThem()
                              ? Colors.black
                              : Colors.white
                          : themeChange.getThem()
                              ? Colors.white
                              : Colors.black,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ));
    }
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          DrawerHeader(
            child: FutureBuilder<UserModel?>(
                future: FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Constant.loader();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        UserModel driverModel = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: CachedNetworkImage(
                                height: Responsive.width(20, context),
                                width: Responsive.width(20, context),
                                imageUrl: driverModel.profilePic.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Constant.loader(),
                                errorWidget: (context, url, error) => Image.network(Constant.userPlaceHolder),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(driverModel.fullName.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                driverModel.email.toString(),
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          ],
                        );
                      }
                    default:
                      return  Text('Error'.tr);
                  }
                }),
          ),
          Column(children: drawerOptions),
        ],
      ),
    );
  }
}
