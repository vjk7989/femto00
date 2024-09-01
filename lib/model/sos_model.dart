class SosModel {
  String? id;
  String? orderId;
  String? status;
  String? orderType;

  SosModel({this.id, this.orderId,this.status,this.orderType});

  SosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    status = json['status'];
    orderType = json['orderType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderId'] = orderId;
    data['status'] = status;
    data['orderType'] = orderType;
    return data;
  }
}
