import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/controller/live_tracking_controller.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LiveTrackingController>(
      init: LiveTrackingController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: AppColors.primary,
            title: Text("Map view".tr),
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                )),
          ),
          body: Constant.selectedMapType == 'osm'
              ? OSMFlutter(
                  controller: controller.mapOsmController,
                  osmOption: const OSMOption(
                    userTrackingOption: UserTrackingOption(
                      enableTracking: false,
                      unFollowUser: false,
                    ),
                    zoomOption: ZoomOption(
                      initZoom: 16,
                      minZoomLevel: 2,
                      maxZoomLevel: 19,
                      stepZoom: 1.0,
                    ),
                    roadConfiguration: RoadOption(
                      roadColor: Colors.yellowAccent,
                    ),
                  ),
                  onMapIsReady: (active) async {
                    if (active) {
                      controller.getArgument();
                      ShowToastDialog.closeLoader();
                    }
                  })
              : Obx(
                  () => GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.terrain,
                    zoomControlsEnabled: false,
                    polylines: Set<Polyline>.of(controller.polyLines.values),
                    padding: const EdgeInsets.only(
                      top: 22.0,
                    ),
                    markers: Set<Marker>.of(controller.markers.values),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                    },
                    initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: LatLng(Constant.currentLocation != null ? Constant.currentLocation!.latitude : 45.521563,
                          Constant.currentLocation != null ? Constant.currentLocation!.longitude : -122.677433),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
