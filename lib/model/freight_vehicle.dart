class FreightVehicle {
  String? image;
  bool? enable;
  String? kmCharge;
  String? width;
  String? length;
  String? name;
  String? id;
  String? height;
  String? description;

  FreightVehicle(
      {this.image,
        this.enable,
        this.kmCharge,
        this.width,
        this.length,
        this.name,
        this.id,
        this.height,this.description});

  FreightVehicle.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    enable = json['enable'];
    kmCharge = json['kmCharge'];
    width = json['width'];
    length = json['length'];
    name = json['name'];
    id = json['id'];
    height = json['height'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['enable'] = enable;
    data['kmCharge'] = kmCharge;
    data['width'] = width;
    data['length'] = length;
    data['name'] = name;
    data['id'] = id;
    data['height'] = height;
    data['description'] = description;
    return data;
  }
}
