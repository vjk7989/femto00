class BannerModel {
  String? image;
  bool? enable;
  String? id;
  String? position;

  BannerModel({this.image, this.enable, this.id, this.position});

  BannerModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    enable = json['enable'];
    id = json['id'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['enable'] = enable;
    data['id'] = id;
    data['position'] = position;
    return data;
  }
}
