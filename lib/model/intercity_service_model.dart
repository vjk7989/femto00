import 'package:customer/model/admin_commission.dart';

class IntercityServiceModel {
  String? image;
  bool? enable;
  String? kmCharge;
  String? name;
  bool? offerRate;
  String? id;
  AdminCommission? adminCommission;

  IntercityServiceModel({this.image, this.enable, this.kmCharge, this.name, this.offerRate, this.id,this.adminCommission});

  IntercityServiceModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    enable = json['enable'];
    kmCharge = json['kmCharge'];
    name = json['name'];
    offerRate = json['offerRate'];
    id = json['id'];
    adminCommission = json['adminCommission'] != null ? AdminCommission.fromJson(json['adminCommission']) : AdminCommission(isEnabled: true,amount: "",type: "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['enable'] = enable;
    data['kmCharge'] = kmCharge;
    data['name'] = name;
    data['offerRate'] = offerRate;
    data['id'] = id;
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    return data;
  }
}
