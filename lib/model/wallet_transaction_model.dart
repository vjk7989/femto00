import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTransactionModel {
  String? amount;
  Timestamp? createdDate;
  String? id;
  String? userId;
  String? transactionId;
  String? paymentType;
  String? note;
  String? orderType;
  String? userType;

  WalletTransactionModel({this.amount, this.createdDate, this.id, this.userId, this.transactionId, this.paymentType, this.note, this.orderType,this.userType});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    createdDate = json['createdDate'];
    id = json['id'];
    userId = json['userId'];
    transactionId = json['transactionId'];
    paymentType = json['paymentType'];
    note = json['note'];
    orderType = json['orderType'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['createdDate'] = createdDate;
    data['id'] = id;
    data['userId'] = userId;
    data['transactionId'] = transactionId;
    data['paymentType'] = paymentType;
    data['note'] = note;
    data['orderType'] = orderType;
    data['userType'] = userType;
    return data;
  }
}
