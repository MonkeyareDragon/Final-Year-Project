// workout.model.Equipment
import 'package:loginsignup/common/url_helper.dart';

class Equipment {
  int id;
  String equipmentImage;
  String name;
  String description;

  Equipment(
      {required this.id,
      required this.equipmentImage,
      required this.name,
      required this.description}) {
    this.equipmentImage = UrlUtil.getImageUrl(equipmentImage);
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      equipmentImage: json['equipment_image'],
      name: json['name'],
      description: json['description'],
    );
  }
}
