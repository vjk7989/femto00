class AdminCommission {
  String? amount;
  bool? isEnabled;
  String? type;

  AdminCommission({this.amount, this.isEnabled, this.type});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    isEnabled = json['isEnabled'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['isEnabled'] = isEnabled;
    data['type'] = type;
    return data;
  }
}
