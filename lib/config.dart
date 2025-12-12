import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  const GrenadeOrigin(this.position, {required this.side});

  GrenadeOrigin.fromJson(dynamic data)
    : position = Point(data['position'][0], data['position'][1]),
      side =
          .values.asNameMap()[(data['side'] as String).toLowerCase()] ?? .both;
}

class Grenade {
  final Point position;
  final GrenadeType type;
  final ThrowType throwType;
  final List<GrenadeOrigin> origins;

  const Grenade({
    required this.position,
    required this.type,
    required this.origins,
    required this.throwType,
  });

  Grenade.fromJson(dynamic data)
    : position = Point(data['position'][0], data['position'][1]),
      type = .values.asNameMap()[(data['type'] as String).toLowerCase()]!,
      throwType =
          .values.asNameMap()[(data['throw'] as String?)?.toLowerCase()] ??
          .stand,
      origins = (data['origins'] as List)
          .map(GrenadeOrigin.fromJson)
          .toList(growable: false);

  Side get side =>
      origins.any((e) => e.side == .both) ? .both : origins.first.side;
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
    : image = AssetImage(
        'images/map/${data['image'] ?? '${data['name']}.png'}',
      ),
      cover = AssetImage(
        'images/cover/${data['image'] ?? '${data['name']}.png'}',
      ),
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

Future<Config> loadConfig() async =>
    .fromJson(jsonDecode(await rootBundle.loadString('config.json')));
