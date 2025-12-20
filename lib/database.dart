import 'dart:convert' show jsonDecode;
import 'dart:io' show Directory, File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

enum Side { counterTerrorist, terrorist, both }

enum GrenadeType { smoke, he, fire, flash }

enum ThrowType { stand, jump }

class GrenadeOrigin {
  final Point position;
  final Side side;
  final List<DbImage> images;

  const GrenadeOrigin(this.position, {this.side = .both, required this.images});

  GrenadeOrigin.fromJson(dynamic data)
    : position = Point(data['position'][0], data['position'][1]),
      images = ((data['images'] as List<String>?) ?? [''])
          .map(DbImage.new)
          .toList(growable: false),
      side =
          .values.asNameMap()[(data['side'] as String).toLowerCase()] ?? .both;
}

class Grenade {
  final Point position;
  final GrenadeType type;
  final ThrowType throwType;
  final DbImage image;
  final List<GrenadeOrigin> origins;

  const Grenade({
    required this.position,
    required this.type,
    required this.origins,
    required this.throwType,
    required this.image,
  });

  Grenade.fromJson(dynamic data)
    : position = Point(data['position'][0], data['position'][1]),
      type = .values.asNameMap()[(data['type'] as String).toLowerCase()]!,
      image = DbImage(data['image'] ?? ''),
      throwType =
          .values.asNameMap()[(data['throw'] as String?)?.toLowerCase()] ??
          .stand,
      origins = (data['origins'] as List)
          .map(GrenadeOrigin.fromJson)
          .toList(growable: false);

  Side get side =>
      origins.any((e) => e.side == .both) ? .both : origins.first.side;
}

class DbImage {
  final String path;
  ImageProvider? _loaded;

  DbImage(this.path);

  Future<ImageProvider> get image async {
    _loaded ??= !kIsWeb
        ? FileImage(File('${(await _dir).path}/images/$path'))
        : MemoryImage(await http.readBytes(_gitUri('images/$path')));
    return _loaded!;
  }
}

class CMap {
  final List<Grenade> grenades;
  final DbImage image;
  final DbImage cover;
  final String name;

  const CMap({
    required this.grenades,
    required this.image,
    required this.cover,
    required this.name,
  });

  CMap.fromJson(dynamic data)
    : image = DbImage(data['image']),
      cover = DbImage(data['cover']),
      name = data['name'],
      grenades = (data['grenades'] as List)
          .map(Grenade.fromJson)
          .toList(growable: false);
}

class Database {
  final List<CMap> maps;

  const Database({required this.maps});

  Database.fromJson(dynamic data)
    : maps = (data['maps'] as List).map(CMap.fromJson).toList(growable: false);
}

Future<Directory> get _dir async => await getApplicationDocumentsDirectory();

Future<File> get _dbFile async => File('${(await _dir).path}/database.json');

Future<bool> _checkUpdates() async {
  final file = File('${(await _dir).path}/version.txt');
  final dbVer = await http.read(_gitUri('version.txt'));
  return !await file.exists() || await file.readAsString() != dbVer;
}

Uri _gitUri(String path) => Uri.https(
  'raw.githubusercontent.com',
  '/FordenRo/standoff_grenader/refs/heads/main/$path',
);

Future<Database> loadDatabase() async {
  final dbFile = !kIsWeb ? await _dbFile : null;
  if (kIsWeb || !await dbFile!.exists() || await _checkUpdates()) {
    String dbContent = await http.read(_gitUri('database.json'));
    final db = Database.fromJson(jsonDecode(dbContent));

    List<Future>? tasks;
    if (!kIsWeb) {
      tasks = [dbFile!.writeAsString(dbContent)];
    }

    for (var map in db.maps) {
      final content = await http.readBytes(_gitUri('images/${map.image.path}'));
      tasks?.add(
        File(
          '${(await _dir).path}/images/${map.image.path}',
        ).writeAsBytes(content),
      );
    }

    tasks?.forEach((e) async => await e);
    return db;
  }

  return .fromJson(jsonDecode(await dbFile.readAsString()));
}
