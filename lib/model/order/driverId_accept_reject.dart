import 'package:cloud_firestore/cloud_firestore.dart';

class DriverIdAcceptReject {
  String? driverId;
  String? offerAmount;
  Timestamp? acceptedRejectTime;
  String? suggestedTime;
  String? suggestedDate;

  DriverIdAcceptReject({this.offerAmount, this.driverId, this.acceptedRejectTime, this.suggestedTime, this.suggestedDate});

  DriverIdAcceptReject.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    offerAmount = json['offerAmount'];
    acceptedRejectTime = json['acceptedRejectTime'];
    suggestedTime = json['suggestedTime'];
    suggestedDate = json['suggestedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offerAmount'] = offerAmount;
    data['driverId'] = driverId;
    data['acceptedRejectTime'] = acceptedRejectTime;
    data['suggestedTime'] = suggestedTime;
    data['suggestedDate'] = suggestedDate;
    return data;
  }
}
