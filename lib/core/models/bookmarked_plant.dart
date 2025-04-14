import 'package:hive/hive.dart';

part 'bookmarked_plant.g.dart';

@HiveType(typeId: 2)
class BookmarkedPlant extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String family;

  @HiveField(3)
  final String image;

  BookmarkedPlant({
    required this.id,
    required this.name,
    required this.family,
    required this.image,
  });
} 