import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? comment;
  String? rating;
  String? id;
  String? customerId;
  String? driverId;
  String? type;
  Timestamp? date;

  ReviewModel({this.comment, this.rating, this.id, this.date, this.customerId, this.driverId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    rating = json['rating'];
    id = json['id'];
    date = json['date'];
    customerId = json['customerId'];
    driverId = json['driverId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['rating'] = rating;
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['driverId'] = driverId;
    data['type'] = type;
    return data;
  }
}
