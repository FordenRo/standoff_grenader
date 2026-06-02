import 'package:flutter/material.dart';

import '../database.dart';

enum Side { both, t, ct }

enum ThrowType { stand, jump, run, crouch, runAndJump }

class GrenadeOrigin {
  const GrenadeOrigin(
    this.position, {
    required this.images,
    this.description,
    this.throwType = .stand,
    this.side = .both,
  });

  GrenadeOrigin.fromMap(Map<String, dynamic> data)
    : position = Offset(
        (data['position'] as List).cast<int>()[0].toDouble(),
        (data['position'] as List).cast<int>()[1].toDouble(),
      ),
      images = ((data['images'] as List?)?.cast<String>() ?? [])
          .map(DbImage.new)
          .toList(),
      description = data['description'] as String?,
      throwType =
          .values.asNameMap()[(data['throw'] as String?)?.toLowerCase()] ??
          .stand,
      side =
          .values.asNameMap()[(data['side'] as String?)?.toLowerCase()] ??
          .both;

  final Offset position;
  final Side side;
  final ThrowType throwType;
  final List<DbImage> images;
  final String? description;
}
