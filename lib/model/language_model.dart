class LanguageModel {
  String? image;
  String? code;
  bool? isDeleted;
  bool? enable;
  String? name;
  String? id;
  bool? isRtl;

  LanguageModel({this.image, this.code, this.isDeleted, this.enable, this.name, this.id, this.isRtl});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    code = json['code'];
    isDeleted = json['isDeleted'];
    enable = json['enable'];
    name = json['name'];
    id = json['id'];
    isRtl = json['isRtl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['code'] = code;
    data['isDeleted'] = isDeleted;
    data['enable'] = enable;
    data['name'] = name;
    data['id'] = id;
    data['isRtl'] = isRtl;
    return data;
  }
}
