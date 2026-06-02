import 'package:flutter/material.dart';
import '../core/models/grenade.dart';
import '../core/models/grenade_origin.dart';

const size = 20.0;

class GrenadeButton extends StatelessWidget {
  const GrenadeButton(
    this.grenade, {
    required this.onPressed,
    required this.scale,
    this.selected = false,
    super.key,
  });

  final Grenade grenade;
  final void Function() onPressed;
  final bool selected;
  final double scale;

  @override
  Widget build(BuildContext context) => _BaseGrenadeButton(
    image: AssetImage(switch (grenade.type) {
      .smoke => 'images/grenade/smoke.png',
      .he => 'images/grenade/he.png',
      .fire => 'images/grenade/fire.png',
      .flash => 'images/grenade/flash.png',
    }),
    onPressed: onPressed,
    selected: selected,
    position: grenade.position,
    scale: scale,
  );
}

class GrenadeOriginButton extends StatelessWidget {
  const GrenadeOriginButton(
    this.origin, {
    required this.onPressed,
    required this.scale,
    super.key,
  });

  final GrenadeOrigin origin;
  final void Function() onPressed;
  final double scale;

  @override
  Widget build(BuildContext context) => _BaseGrenadeButton(
    image: const AssetImage('images/grenade/origin.png'),
    onPressed: onPressed,
    position: origin.position,
    scale: scale,
  );
}

ButtonStyle _getStyle(BuildContext context) => .new(
  minimumSize: .all(.zero),
  padding: .all(const .all(6)),
  shape: .fromMap({
    WidgetState.selected: CircleBorder(
      side: .new(color: Theme.of(context).colorScheme.primary),
    ),
    WidgetState.any: null,
  }),
  backgroundColor: .fromMap({
    WidgetState.selected: Theme.of(context).colorScheme.primary.withAlpha(100),
    WidgetState.any: null,
  }),
);

class _BaseGrenadeButton extends StatelessWidget {
  const _BaseGrenadeButton({
    required this.image,
    required this.onPressed,
    required this.position,
    required this.scale,
    this.selected = false,
  });

  final ImageProvider<Object> image;
  final void Function() onPressed;
  final Offset position;
  final bool selected;
  final double scale;

  @override
  Widget build(BuildContext context) => Transform.translate(
    offset: position - const Offset((size + 12) / 2, (size + 12) / 2),
    child: Transform.scale(
      scale: scale,
      child: IconButton(
        isSelected: selected,
        onPressed: onPressed,
        splashRadius: 1,
        style: _getStyle(context),
        icon: Image(image: image, width: size, height: size),
      ),
    ),
  );
}
