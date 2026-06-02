import '../database.dart';
import 'grenade.dart';

class MapModel {
  const MapModel({
    required this.grenades,
    required this.image,
    required this.cover,
    required this.name,
  });

  MapModel.fromMap(Map<String, dynamic> data)
    : image = DbImage(data['image'] as String),
      cover = DbImage(data['cover'] as String),
      name = data['name'] as String,
      grenades = (data['grenades'] as List)
          .cast<Map<String, dynamic>>()
          .map(Grenade.fromMap)
          .toList(growable: false);

  final List<Grenade> grenades;
  final DbImage image;
  final DbImage cover;
  final String name;
}
