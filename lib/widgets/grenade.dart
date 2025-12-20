import 'package:flutter/material.dart';
import 'package:standoff_grenader/database.dart'
    show Grenade, GrenadeOrigin, Point;

const double size = 16;

class PlaceButton extends StatelessWidget {
  final ImageProvider<Object> image;
  final void Function() onPressed;
  final Point position;

  const PlaceButton({
    super.key,
    required this.image,
    required this.onPressed,
    required this.position,
  });

  @override
  Widget build(BuildContext context) => Positioned(
    left: position.x.toDouble() - size / 2,
    top: position.y.toDouble() - size / 2,
    child: IconButton(
      onPressed: onPressed,
      alignment: .center,
      style: ButtonStyle(
        minimumSize: .all(.fromRadius(0)),
        padding: .all(.all(6)),
      ),
      icon: Image(width: size, height: size, image: image),
    ),
  );
}

class GrenadeWidget extends StatelessWidget {
  final Grenade grenade;
  final void Function() onPressed;

  const GrenadeWidget(this.grenade, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) => PlaceButton(
    image: AssetImage(switch (grenade.type) {
      .smoke => 'images/grenade/smoke.png',
      .he => 'images/grenade/he.png',
      .fire => 'images/grenade/fire.png',
      .flash => 'images/grenade/flash.png',
    }),
    onPressed: onPressed,
    position: grenade.position,
  );
}

class GrenadeOriginWidget extends StatelessWidget {
  final GrenadeOrigin origin;
  final void Function() onPressed;

  const GrenadeOriginWidget(this.origin, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) => PlaceButton(
    image: AssetImage('images/grenade/origin.png'),
    onPressed: onPressed,
    position: origin.position,
  );
}
