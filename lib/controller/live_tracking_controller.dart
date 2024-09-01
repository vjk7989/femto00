import 'dart:math';
import 'package:customer/constant/collection_name.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/model/driver_user_model.dart';
import 'package:customer/model/intercity_order_model.dart';
import 'package:customer/model/order_model.dart';
import 'package:customer/themes/app_colors.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingController extends GetxController {
  GoogleMapController? mapController;

  @override
  void onInit() {
    addMarkerSetup();
    if (Constant.selectedMapType == 'osm') {
      ShowToastDialog.showLoader("Please wait");
      mapOsmController = MapController(initPosition: GeoPoint(latitude: 20.9153, longitude: -100.7439), useExternalTracking: false); //OSM
    } else {
      getArgument();
    }

    super.onInit();
  }

  @override
  void onClose() {
    ShowToastDialog.closeLoader();
    super.onClose();
  }

  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<InterCityOrderModel> intercityOrderModel = InterCityOrderModel().obs;

  RxBool isLoading = true.obs;
  RxString type = "".obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      type.value = argumentData['type'];

      if (type.value == "orderModel") {
        OrderModel argumentOrderModel = argumentData['orderModel'];
        FireStoreUtils.fireStore.collection(CollectionName.orders).doc(argumentOrderModel.id).snapshots().listen((event) {
          if (event.data() != null) {
            OrderModel orderModelStream = OrderModel.fromJson(event.data()!);
            print(orderModelStream.status.toString());
            orderModel.value = orderModelStream;
            FireStoreUtils.fireStore.collection(CollectionName.driverUsers).doc(argumentOrderModel.driverId).snapshots().listen((event) {
              if (event.data() != null) {
                driverUserModel.value = DriverUserModel.fromJson(event.data()!);
                if (Constant.selectedMapType != 'osm') {
                  if (orderModel.value.status == Constant.rideInProgress) {
                    getPolyline(
                        sourceLatitude: driverUserModel.value.location!.latitude,
                        sourceLongitude: driverUserModel.value.location!.longitude,
                        destinationLatitude: orderModel.value.destinationLocationLAtLng!.latitude,
                        destinationLongitude: orderModel.value.destinationLocationLAtLng!.longitude);
                  } else {
                    getPolyline(
                        sourceLatitude: driverUserModel.value.location!.latitude,
                        sourceLongitude: driverUserModel.value.location!.longitude,
                        destinationLatitude: orderModel.value.sourceLocationLAtLng!.latitude,
                        destinationLongitude: orderModel.value.sourceLocationLAtLng!.longitude);
                  }
                } else {
                  if (orderModel.value.status == Constant.rideInProgress) {
                    setOsmMarker(
                      departure: GeoPoint(latitude: orderModel.value.sourceLocationLAtLng?.latitude ?? 0.0, longitude: orderModel.value.sourceLocationLAtLng?.longitude ?? 0.0),
                      destination:
                          GeoPoint(latitude: orderModel.value.destinationLocationLAtLng?.latitude ?? 0.0, longitude: orderModel.value.destinationLocationLAtLng?.longitude ?? 0.0),
                    );
                  } else {
                    setOsmMarker(
                      departure: GeoPoint(latitude: orderModel.value.sourceLocationLAtLng?.latitude ?? 0.0, longitude: orderModel.value.sourceLocationLAtLng?.longitude ?? 0.0),
                      destination: GeoPoint(latitude: orderModel.value.sourceLocationLAtLng!.latitude ?? 0.0, longitude: orderModel.value.sourceLocationLAtLng!.longitude ?? 0.0),
                    );
                  }
                }
              }
            });

            if (orderModel.value.status == Constant.rideComplete) {
              Get.back();
            }
          }
        });
      } else {
        InterCityOrderModel argumentOrderModel = argumentData['interCityOrderModel'];
        FireStoreUtils.fireStore.collection(CollectionName.ordersIntercity).doc(argumentOrderModel.id).snapshots().listen((event) {
          if (event.data() != null) {
            InterCityOrderModel orderModelStream = InterCityOrderModel.fromJson(event.data()!);
            print(orderModelStream.status.toString());
            intercityOrderModel.value = orderModelStream;
            FireStoreUtils.fireStore.collection(CollectionName.driverUsers).doc(argumentOrderModel.driverId).snapshots().listen((event) {
              if (event.data() != null) {
                driverUserModel.value = DriverUserModel.fromJson(event.data()!);
                if (Constant.selectedMapType != 'osm') {
                  if (intercityOrderModel.value.status == Constant.rideInProgress) {
                    getPolyline(
                        sourceLatitude: driverUserModel.value.location!.latitude,
                        sourceLongitude: driverUserModel.value.location!.longitude,
                        destinationLatitude: intercityOrderModel.value.destinationLocationLAtLng!.latitude,
                        destinationLongitude: intercityOrderModel.value.destinationLocationLAtLng!.longitude);
                  } else {
                    getPolyline(
                        sourceLatitude: driverUserModel.value.location!.latitude,
                        sourceLongitude: driverUserModel.value.location!.longitude,
                        destinationLatitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude,
                        destinationLongitude: intercityOrderModel.value.sourceLocationLAtLng!.longitude);
                  }
                } else {
                  if (orderModel.value.status == Constant.rideInProgress) {
                    setOsmMarker(
                      departure: GeoPoint(
                        latitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude ?? 0.0,
                        longitude: intercityOrderModel.value.sourceLocationLAtLng!.longitude ?? 0.0,
                      ),
                      destination: GeoPoint(
                          latitude: intercityOrderModel.value.destinationLocationLAtLng!.latitude ?? 0.0,
                          longitude: intercityOrderModel.value.destinationLocationLAtLng!.longitude ?? 0.0),
                    );
                  } else {
                    setOsmMarker(
                      departure: GeoPoint(
                        latitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude ?? 0.0,
                        longitude: intercityOrderModel.value.sourceLocationLAtLng!.longitude ?? 0.0,
                      ),
                      destination: GeoPoint(
                        latitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude ?? 0.0,
                        longitude: intercityOrderModel.value.sourceLocationLAtLng!.longitude ?? 0.0,
                      ),
                    );
                  }
                }
              }
            });

            if (intercityOrderModel.value.status == Constant.rideComplete) {
              Get.back();
            }
          }
        });
      }
    }
    isLoading.value = false;
    update();
  }

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  void getPolyline({required double? sourceLatitude, required double? sourceLongitude, required double? destinationLatitude, required double? destinationLongitude}) async {
    if (sourceLatitude != null && sourceLongitude != null && destinationLatitude != null && destinationLongitude != null) {
      List<LatLng> polylineCoordinates = [];
      PolylineRequest polylineRequest = PolylineRequest(
        origin: PointLatLng(sourceLatitude, sourceLongitude),
        destination: PointLatLng(destinationLatitude, destinationLongitude),
        mode: TravelMode.driving,
      );

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: polylineRequest,
        googleApiKey: Constant.mapAPIKey,
      );
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        print(result.errorMessage.toString());
      }

      if (type.value == "orderModel") {
        addMarker(
            latitude: orderModel.value.sourceLocationLAtLng!.latitude,
            longitude: orderModel.value.sourceLocationLAtLng!.longitude,
            id: "Departure",
            descriptor: departureIcon!,
            rotation: 0.0);
        addMarker(
            latitude: orderModel.value.destinationLocationLAtLng!.latitude,
            longitude: orderModel.value.destinationLocationLAtLng!.longitude,
            id: "Destination",
            descriptor: destinationIcon!,
            rotation: 0.0);
        addMarker(
            latitude: driverUserModel.value.location!.latitude,
            longitude: driverUserModel.value.location!.longitude,
            id: "Driver",
            descriptor: driverIcon!,
            rotation: driverUserModel.value.rotation);

        _addPolyLine(polylineCoordinates);
      } else {
        addMarker(
            latitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude,
            longitude: intercityOrderModel.value.sourceLocationLAtLng!.longitude,
            id: "Departure",
            descriptor: departureIcon!,
            rotation: 0.0);
        addMarker(
            latitude: intercityOrderModel.value.destinationLocationLAtLng!.latitude,
            longitude: intercityOrderModel.value.destinationLocationLAtLng!.longitude,
            id: "Destination",
            descriptor: destinationIcon!,
            rotation: 0.0);
        addMarker(
            latitude: driverUserModel.value.location!.latitude,
            longitude: driverUserModel.value.location!.longitude,
            id: "Driver",
            descriptor: driverIcon!,
            rotation: driverUserModel.value.rotation);

        _addPolyLine(polylineCoordinates);
      }
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  addMarker({required double? latitude, required double? longitude, required String id, required BitmapDescriptor descriptor, required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: LatLng(latitude ?? 0.0, longitude ?? 0.0), rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  addMarkerSetup() async {
    if (Constant.selectedMapType != 'osm') {
      final Uint8List departure = await Constant().getBytesFromAsset('assets/images/pickup.png', 100);
      final Uint8List destination = await Constant().getBytesFromAsset('assets/images/dropoff.png', 100);
      final Uint8List driver = await Constant().getBytesFromAsset('assets/images/ic_cab.png', 50);
      departureIcon = BitmapDescriptor.fromBytes(departure);
      destinationIcon = BitmapDescriptor.fromBytes(destination);
      driverIcon = BitmapDescriptor.fromBytes(driver);
    } else {
      departureOsmIcon = Image.asset("assets/images/pickup.png", width: 30, height: 30); //OSM
      destinationOsmIcon = Image.asset("assets/images/dropoff.png", width: 30, height: 30); //OSM
      driverOsmIcon = Image.asset("assets/images/ic_cab.png", width: 30, height: 30); //OSM
    }
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      startCap: Cap.roundCap,
      width: 6,
    );
    polyLines[id] = polyline;
    updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: LatLng(source.latitude, destination.longitude), northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(southwest: LatLng(destination.latitude, source.longitude), northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  //OSM
  late MapController mapOsmController;
  Rx<RoadInfo> roadInfo = RoadInfo().obs;
  Map<String, GeoPoint> osmMarkers = <String, GeoPoint>{};
  Image? departureOsmIcon; //OSM
  Image? destinationOsmIcon; //OSM
  Image? driverOsmIcon;

  void getOSMPolyline() async {
    try {
      GeoPoint destinationLocation;
      if (type.value == "orderModel") {
        if (orderModel.value.status == Constant.rideInProgress) {
          destinationLocation =
              GeoPoint(latitude: orderModel.value.destinationLocationLAtLng!.latitude ?? 0, longitude: orderModel.value.destinationLocationLAtLng!.longitude ?? 0);
        } else {
          destinationLocation = GeoPoint(latitude: orderModel.value.sourceLocationLAtLng!.latitude ?? 0, longitude: orderModel.value.sourceLocationLAtLng!.longitude ?? 0);
        }
      } else {
        if (type.value == "orderModel") {
          destinationLocation =
              GeoPoint(latitude: intercityOrderModel.value.destinationLocationLAtLng!.latitude ?? 0, longitude: intercityOrderModel.value.destinationLocationLAtLng!.latitude ?? 0);
        } else {
          destinationLocation =
              GeoPoint(latitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude ?? 0, longitude: intercityOrderModel.value.sourceLocationLAtLng!.latitude ?? 0);
        }
      }
      if (orderModel.value.destinationLocationLAtLng != null) {
        await mapOsmController.removeLastRoad();
        roadInfo.value = await mapOsmController.drawRoad(
          GeoPoint(latitude: driverUserModel.value.location!.latitude!, longitude: driverUserModel.value.location!.longitude!),
          destinationLocation,
          roadType: RoadType.car,
          roadOption: const RoadOption(
            roadWidth: 15,
            roadColor: AppColors.primary, //themeChange ? AppColors.darkModePrimary :
            zoomInto: false,
          ),
        );
        mapOsmController.moveTo(
          GeoPoint(latitude: driverUserModel.value.location!.latitude!, longitude: driverUserModel.value.location!.longitude!),
          animate: true,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateOSMCameraLocation({required GeoPoint source, required GeoPoint destination}) async {
    BoundingBox bounds;

    if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.longitude > destination.longitude) {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: source.longitude,
        west: destination.longitude,
      );
    } else if (source.latitude > destination.latitude) {
      bounds = BoundingBox(
        north: source.latitude,
        south: destination.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    } else {
      bounds = BoundingBox(
        north: destination.latitude,
        south: source.latitude,
        east: destination.longitude,
        west: source.longitude,
      );
    }

    await mapOsmController.zoomToBoundingBox(bounds, paddinInPixel: 100);
  }

  setOsmMarker({required GeoPoint departure, required GeoPoint destination}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (osmMarkers.containsKey('Driver')) {
        await mapOsmController.removeMarker(osmMarkers['Driver']!);
      }

      await mapOsmController
          .addMarker(GeoPoint(latitude: driverUserModel.value.location!.latitude!, longitude: driverUserModel.value.location!.longitude!),
              markerIcon: MarkerIcon(iconWidget: driverOsmIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ))
          .then((v) {
        osmMarkers['Driver'] = GeoPoint(latitude: driverUserModel.value.location!.latitude!, longitude: driverUserModel.value.location!.longitude!);
      });

      if (osmMarkers.containsKey('Source')) {
        await mapOsmController.removeMarker(osmMarkers['Source']!);
      }
      await mapOsmController
          .addMarker(departure,
              markerIcon: MarkerIcon(iconWidget: departureOsmIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ))
          .then((v) {
        osmMarkers['Source'] = departure;
      });

      if (osmMarkers.containsKey('Destination')) {
        await mapOsmController.removeMarker(osmMarkers['Destination']!);
      }

      await mapOsmController
          .addMarker(destination,
              markerIcon: MarkerIcon(iconWidget: destinationOsmIcon),
              angle: pi / 3,
              iconAnchor: IconAnchor(
                anchor: Anchor.top,
              ))
          .then((v) {
        osmMarkers['Destination'] = destination;
      });
    });
    getOSMPolyline();
  }
}
