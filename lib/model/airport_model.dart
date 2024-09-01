import 'package:cloud_firestore/cloud_firestore.dart';

class AriPortModel {
  Timestamp? date;
  String? airportLng;
  String? airportName;
  String? country;
  String? cityLocation;
  String? id;
  String? state;
  String? airportLat;

  AriPortModel(
      {this.date,
        this.airportLng,
        this.airportName,
        this.country,
        this.cityLocation,
        this.id,
        this.state,
        this.airportLat});

  AriPortModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    airportLng = json['airportLng'];
    airportName = json['airportName'];
    country = json['country'];
    cityLocation = json['cityLocation'];
    id = json['id'];
    state = json['state'];
    airportLat = json['airportLat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['airportLng'] = airportLng;
    data['airportName'] = airportName;
    data['country'] = country;
    data['cityLocation'] = cityLocation;
    data['id'] = id;
    data['state'] = state;
    data['airportLat'] = airportLat;
    return data;
  }
}
