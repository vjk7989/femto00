import 'package:cloud_firestore/cloud_firestore.dart';

class InboxModel {
  String? customerId;
  String? customerName;
  String? customerProfileImage;
  String? lastMessage;
  String? orderId;
  String? driverId;
  String? driverName;
  String? driverProfileImage;
  String? lastSenderId;
  Timestamp? createdAt;

  InboxModel({
    this.customerId,
    this.customerName,
    this.customerProfileImage,
    this.lastMessage,
    this.orderId,
    this.driverId,
    this.driverName,
    this.driverProfileImage,
    this.lastSenderId,
    this.createdAt,
  });

  factory InboxModel.fromJson(Map<String, dynamic> parsedJson) {
    return InboxModel(
      customerId: parsedJson['customerId'] ?? '',
      customerName: parsedJson['customerName'] ?? '',
      customerProfileImage: parsedJson['customerProfileImage'] ?? '',
      lastMessage: parsedJson['lastMessage'],
      orderId: parsedJson['orderId'],
      driverId: parsedJson['driverId'] ?? '',
      driverName: parsedJson['driverName'] ?? '',
      driverProfileImage: parsedJson['driverProfileImage'] ?? '',
      lastSenderId: parsedJson['lastSenderId'] ?? '',
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerProfileImage': customerProfileImage,
      'lastMessage': lastMessage,
      'orderId': orderId,
      'driverId': driverId,
      'driverName': driverName,
      'driverProfileImage': driverProfileImage,
      'lastSenderId': lastSenderId,
      'createdAt': createdAt,
    };
  }
}
