import 'package:flutter/material.dart';
import 'package:standoff_grenader/config.dart' show Grenade;

class GrenadeWidget extends StatelessWidget {
  final Grenade grenade;
  final void Function() onPressed;

  const GrenadeWidget(this.grenade, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: grenade.position.x.toDouble(),
      top: grenade.position.y.toDouble(),
      child: IconButton(onPressed: onPressed, icon: const Icon(Icons.abc)),
    );
  }
}
