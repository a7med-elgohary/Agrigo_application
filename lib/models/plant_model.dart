import 'package:hive/hive.dart';

part 'plant_model.g.dart'; // ملف سيتم إنشاؤه تلقائيًا باستخدام build_runner

@HiveType(typeId: 0) // تأكد من أن typeId فريد
class PlantModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String imageUrl;

  PlantModel({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}
