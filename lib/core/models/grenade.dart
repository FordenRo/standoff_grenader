import 'package:flutter/material.dart';
import 'grenade_origin.dart';

enum GrenadeType { smoke, he, fire, flash }

class Grenade {
  const Grenade({
    required this.position,
    required this.type,
    required this.origins,
    this.description,
  });

  Grenade.fromMap(Map<String, dynamic> data)
    : position = Offset(
        (data['position'] as List).cast<int>()[0].toDouble(),
        (data['position'] as List).cast<int>()[1].toDouble(),
      ),
      type = .values.asNameMap()[(data['type'] as String).toLowerCase()]!,
      description = data['description'] as String?,
      origins = (data['origins'] as List)
          .cast<Map<String, dynamic>>()
          .map(GrenadeOrigin.fromMap)
          .toList(growable: false);

  final Offset position;
  final String? description;
  final GrenadeType type;
  final List<GrenadeOrigin> origins;

  Side get side =>
      origins.any((e) => e.side == .both) ? .both : origins.first.side;
}
