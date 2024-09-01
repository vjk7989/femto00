class ReferralModel {
  String? referralCode;
  String? referralBy;
  String? id;

  ReferralModel({this.referralCode, this.referralBy, this.id});

  ReferralModel.fromJson(Map<String, dynamic> json) {
    referralCode = json['referralCode'];
    referralBy = json['referralBy'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['referralCode'] = referralCode;
    data['referralBy'] = referralBy;
    data['id'] = id;
    return data;
  }
}
