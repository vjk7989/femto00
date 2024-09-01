import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/model/driver_rules_model.dart';
import 'package:customer/model/order/location_lat_lng.dart';
import 'package:customer/model/order/positions.dart';

class DriverUserModel {
  String? phoneNumber;
  String? loginType;
  String? countryCode;
  String? profilePic;
  bool? documentVerification;
  String? fullName;
  bool? isOnline;
  String? id;
  String? serviceId;
  String? fcmToken;
  String? email;
  VehicleInformation? vehicleInformation;
  String? reviewsCount;
  String? reviewsSum;
  String? walletAmount;
  LocationLatLng? location;
  double? rotation;
  Positions? position;
  Timestamp? createdAt;

  DriverUserModel(
      {this.phoneNumber,
        this.loginType,
        this.countryCode,
        this.profilePic,
        this.documentVerification,
        this.fullName,
        this.isOnline,
        this.id,
        this.serviceId,
        this.fcmToken,
        this.email,
        this.location,
        this.vehicleInformation,
        this.reviewsCount,
        this.reviewsSum,
        this.rotation,
        this.position,
        this.walletAmount,this.createdAt});

  DriverUserModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    loginType = json['loginType'];
    countryCode = json['countryCode'];
    profilePic = json['profilePic'] ?? '';
    documentVerification = json['documentVerification'];
    fullName = json['fullName'];
    isOnline = json['isOnline'];
    id = json['id'];
    serviceId = json['serviceId'];
    fcmToken = json['fcmToken'];
    email = json['email'];
    vehicleInformation = json['vehicleInformation'] != null ? VehicleInformation.fromJson(json['vehicleInformation']) : null;
    reviewsCount = json['reviewsCount'] ?? '0.0';
    reviewsSum = json['reviewsSum'] ?? '0.0';
    rotation = json['rotation'];
    walletAmount = json['walletAmount'] ?? "0.0";
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : null;
    position = json['position'] != null ? Positions.fromJson(json['position']) : null;
    createdAt = json['createdAt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['loginType'] = loginType;
    data['countryCode'] = countryCode;
    data['profilePic'] = profilePic;
    data['documentVerification'] = documentVerification;
    data['fullName'] = fullName;
    data['isOnline'] = isOnline;
    data['id'] = id;
    data['serviceId'] = serviceId;
    data['fcmToken'] = fcmToken;
    data['email'] = email;
    data['rotation'] = rotation;
    data['createdAt'] = createdAt;
    if (vehicleInformation != null) {
      data['vehicleInformation'] = vehicleInformation!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['reviewsCount'] = reviewsCount;
    data['reviewsSum'] = reviewsSum;
    data['walletAmount'] = walletAmount;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    return data;
  }
}

class VehicleInformation {
  String? vehicleType;
  String? vehicleTypeId;
  Timestamp? registrationDate;
  String? vehicleColor;
  String? vehicleNumber;
  String? seats;
  List<DriverRulesModel>? driverRules;

  VehicleInformation({this.vehicleType, this.vehicleTypeId, this.registrationDate, this.vehicleColor, this.vehicleNumber, this.seats,this.driverRules});

  VehicleInformation.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicleType'];
    vehicleTypeId = json['vehicleTypeId'];
    registrationDate = json['registrationDate'];
    vehicleColor = json['vehicleColor'];
    vehicleNumber = json['vehicleNumber'];
    seats = json['seats'];
    if (json['driverRules'] != null) {
      driverRules = <DriverRulesModel>[];
      json['driverRules'].forEach((v) {
        driverRules!.add(DriverRulesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicleType'] = vehicleType;
    data['vehicleTypeId'] = vehicleTypeId;
    data['registrationDate'] = registrationDate;
    data['vehicleColor'] = vehicleColor;
    data['vehicleNumber'] = vehicleNumber;
    data['seats'] = seats;
    if (driverRules != null) {
      data['driverRules'] = driverRules!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
