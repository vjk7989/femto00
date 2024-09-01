class FaqModel {
  String? description;
  bool? enable;
  String? id;
  String? title;
  bool? isShow;

  FaqModel({this.description, this.enable, this.id, this.title, this.isShow});

  FaqModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    enable = json['enable'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['enable'] = enable;
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
