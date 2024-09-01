import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/model/admin_commission.dart';
import 'package:customer/model/coupon_model.dart';
import 'package:customer/model/freight_vehicle.dart';
import 'package:customer/model/intercity_service_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/order/positions.dart';
import 'package:customer/model/tax_model.dart';
import 'package:customer/model/zone_model.dart';

import 'contact_model.dart';

class InterCityOrderModel {
  String? sourceCity;
  String? sourceLocationName;
  String? destinationCity;
  String? destinationLocationName;
  String? paymentType;
  LocationLatLng? sourceLocationLAtLng;
  LocationLatLng? destinationLocationLAtLng;
  String? id;
  String? intercityServiceId;
  String? userId;
  String? offerRate;
  String? finalRate;
  String? distance;
  String? distanceType;
  String? status;
  String? driverId;
  String? parcelDimension;
  String? parcelWeight;
  List<dynamic>? parcelImage;
  List<dynamic>? acceptedDriverId;
  List<dynamic>? rejectedDriverId;
  Positions? position;
  Timestamp? createdDate;
  Timestamp? updateDate;

  bool? paymentStatus;
  List<TaxModel>? taxList;
  CouponModel? coupon;
  FreightVehicle? freightVehicle;
  IntercityServiceModel? intercityService;
  String? whenDates;
  String? whenTime;
  String? numberOfPassenger;
  String? comments;
  String? otp;
  ContactModel? someOneElse;
  AdminCommission? adminCommission;
  ZoneModel? zone;
  String? zoneId;

  InterCityOrderModel(
      {this.position,
        this.intercityServiceId,
        this.paymentType,
        this.sourceLocationName,
        this.sourceCity,
        this.destinationLocationName,
        this.destinationCity,
        this.sourceLocationLAtLng,
        this.destinationLocationLAtLng,
        this.id,
        this.userId,
        this.distance,
        this.distanceType,
        this.status,
        this.driverId,
        this.parcelWeight,
        this.parcelDimension,
        this.offerRate,
        this.finalRate,
        this.paymentStatus,
        this.createdDate,
        this.updateDate,
        this.taxList,
        this.coupon,
        this.intercityService,
        this.whenTime,
        this.numberOfPassenger,
        this.whenDates,
        this.comments,
        this.otp,
        this.someOneElse,
        this.adminCommission,this.zone,this.zoneId});

  InterCityOrderModel.fromJson(Map<String, dynamic> json) {
    intercityServiceId = json['intercityServiceId'];
    sourceLocationName = json['sourceLocationName'];
    sourceCity = json['sourceCity'];
    paymentType = json['paymentType'];
    destinationLocationName = json['destinationLocationName'];
    destinationCity = json['destinationCity'];
    sourceLocationLAtLng = json['sourceLocationLAtLng'] != null ? LocationLatLng.fromJson(json['sourceLocationLAtLng']) : null;
    destinationLocationLAtLng = json['destinationLocationLAtLng'] != null ? LocationLatLng.fromJson(json['destinationLocationLAtLng']) : null;
    coupon = json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    freightVehicle = json['freightVehicle'] != null ? FreightVehicle.fromJson(json['freightVehicle']) : null;
    intercityService = json['intercityService'] != null ? IntercityServiceModel.fromJson(json['intercityService']) : null;
    id = json['id'];
    userId = json['userId'];
    offerRate = json['offerRate'];
    finalRate = json['finalRate'];
    distance = json['distance'];
    distanceType = json['distanceType'];
    status = json['status'];
    driverId = json['driverId'];
    parcelWeight = json['parcelWeight'];
    parcelDimension = json['parcelDimension'];
    createdDate = json['createdDate'];
    updateDate = json['updateDate'];
    parcelImage = json['parcelImage'];
    acceptedDriverId = json['acceptedDriverId'];
    rejectedDriverId = json['rejectedDriverId'];
    paymentStatus = json['paymentStatus'];
    whenTime = json['whenTime'];
    whenDates = json['whenDates'];
    numberOfPassenger = json['numberOfPassenger'];
    comments = json['comments'];
    otp = json['otp'];
    position = json['position'] != null ? Positions.fromJson(json['position']) : null;
    adminCommission = json['adminCommission'] != null ? AdminCommission.fromJson(json['adminCommission']) : null;
    someOneElse = json['someOneElse'] != null ? ContactModel.fromJson(json['someOneElse']) : null;
    zone = json['zone'] != null ? ZoneModel.fromJson(json['zone']) : null;
    zoneId = json['zoneId'];
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['intercityServiceId'] = intercityServiceId;
    data['sourceLocationName'] = sourceLocationName;
    data['sourceCity'] = sourceCity;
    data['destinationLocationName'] = destinationLocationName;
    data['destinationCity'] = destinationCity;
    if (sourceLocationLAtLng != null) {
      data['sourceLocationLAtLng'] = sourceLocationLAtLng!.toJson();
    }
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    if (freightVehicle != null) {
      data['freightVehicle'] = freightVehicle!.toJson();
    }
    if (intercityService != null) {
      data['intercityService'] = intercityService!.toJson();
    }
    if (someOneElse != null) {
      data['someOneElse'] = someOneElse!.toJson();
    }
    if (destinationLocationLAtLng != null) {
      data['destinationLocationLAtLng'] = destinationLocationLAtLng!.toJson();
    }
    if (zone != null) {
      data['zone'] = zone!.toJson();
    }
    data['zoneId'] = zoneId;
    data['id'] = id;
    data['userId'] = userId;
    data['paymentType'] = paymentType;
    data['offerRate'] = offerRate;
    data['finalRate'] = finalRate;
    data['distance'] = distance;
    data['distanceType'] = distanceType;
    data['status'] = status;
    data['driverId'] = driverId;
    data['parcelWeight'] = parcelWeight;
    data['parcelDimension'] = parcelDimension;
    data['createdDate'] = createdDate;
    data['updateDate'] = updateDate;
    data['parcelImage'] = parcelImage;
    data['acceptedDriverId'] = acceptedDriverId;
    data['rejectedDriverId'] = rejectedDriverId;
    data['paymentStatus'] = paymentStatus;
    data['whenTime'] = whenTime;
    data['whenDates'] = whenDates;
    data['numberOfPassenger'] = numberOfPassenger;
    data['comments'] = comments;
    data['otp'] = otp;
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    return data;
  }
}
