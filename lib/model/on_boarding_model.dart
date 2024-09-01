class OnBoardingModel {
  String? image;
  String? description;
  String? id;
  String? title;

  OnBoardingModel({this.image, this.description, this.id, this.title});

  OnBoardingModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    description = json['description'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['description'] = description;
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
