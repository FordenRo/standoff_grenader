import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

enum Side { counterTerrorist, terrorist, both }

class Grenade {
  final Point position;
  final String name;
  final Side side;

  const Grenade({
    required this.position,
    required this.name,
    required this.side,
  });

  Grenade.fromJson(dynamic data)
    : name = data['name'],
      position = Point(data['position'][0], data['position'][1]),
      side = switch ((data['side'] as String).toLowerCase()) {
        'ct' => .counterTerrorist,
        't' => .terrorist,
        _ => .both,
      };
}

class CMap {
  final List<Grenade> grenades;
  final AssetImage image;
  final AssetImage cover;
  final String name;

  const CMap({
    required this.grenades,
    required this.image,
    required this.cover,
    required this.name,
  });

  CMap.fromJson(dynamic data)
    : image = AssetImage(data['image']),
      cover = AssetImage(data['cover']),
      name = data['name'],
      grenades = (data['grenades'] as List)
          .map(Grenade.fromJson)
          .toList(growable: false);
}

class Config {
  final List<CMap> maps;

  const Config({required this.maps});

  Config.fromJson(dynamic data)
    : maps = (data['maps'] as List).map(CMap.fromJson).toList(growable: false);
}

Future<Config> loadConfig() async {
  return Config.fromJson(
    jsonDecode(await rootBundle.loadString('config.json')),
  );
}
