import 'package:booking_system_flutter/utils/images.dart';

class Servicedata {
  String? name;
  String? rating;
  String? icon;

  Servicedata({this.name, this.rating, this.icon});

  Servicedata.fromJson(
      Map<String, dynamic> json, this.name, this.icon, this.rating) {
    name = json['name'];
    icon = json['icon'];
    rating = json['rating'];
  }
}

List<Servicedata> serviceData = [
  Servicedata(name: 'kamla', rating: '5', icon: appLogo),
  Servicedata(name: 'Savita', rating: '4.5', icon: appLogo),
  Servicedata(name: 'Rani', rating: '4.0', icon: appLogo),
  Servicedata(name: 'kitti', rating: '3.0', icon: appLogo),
  Servicedata(name: 'Monisha', rating: '3.5', icon: appLogo),
];
