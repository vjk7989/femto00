class DriverRulesModel {
  String? image;
  bool? isDeleted;
  bool? enable;
  String? name;
  String? id;

  DriverRulesModel({this.image, this.isDeleted, this.enable, this.name, this.id});

  DriverRulesModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    isDeleted = json['isDeleted'];
    enable = json['enable'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['isDeleted'] = isDeleted;
    data['enable'] = enable;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
