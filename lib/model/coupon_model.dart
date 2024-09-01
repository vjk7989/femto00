import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? title;
  String? amount;
  String? code;
  bool? enable;
  String? id;
  Timestamp? validity;
  String? type;

  CouponModel({this.title, this.amount, this.code, this.enable, this.id, this.validity, this.type});

  CouponModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    amount = json['amount'];
    code = json['code'];
    enable = json['enable'];
    id = json['id'];
    validity = json['validity'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['amount'] = amount;
    data['code'] = code;
    data['enable'] = enable;
    data['id'] = id;
    data['validity'] = validity;
    data['type'] = type;
    return data;
  }
}
