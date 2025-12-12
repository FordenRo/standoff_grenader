import 'package:flutter/material.dart';
import 'package:standoff_grenader/config.dart' show Grenade, GrenadeOrigin;

class GrenadeInfoSheet extends StatelessWidget {
  final GrenadeOrigin origin;
  final Grenade grenade;

  const GrenadeInfoSheet(this.grenade, this.origin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 200);
  }
}
