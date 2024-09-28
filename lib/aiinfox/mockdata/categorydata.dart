import 'package:booking_system_flutter/utils/images.dart';

class CategoryData {
  String? name;
  String? icon;

  CategoryData({this.name, this.icon});

  CategoryData.fromJson(Map<String, dynamic> json, this.name, this.icon) {
    name = json['name'];
    icon = json['icon'];
  }
}

List<CategoryData> categotyData = [
  CategoryData(name: 'House Maid', icon: appLogo),
  CategoryData(name: 'Baby Sitter', icon: appLogo),
  CategoryData(name: 'Cleaning', icon: appLogo),
  CategoryData(name: 'Cooking', icon: appLogo),
  CategoryData(name: 'Nanny', icon: appLogo),
  CategoryData(name: 'Care Taker', icon: appLogo),
];
