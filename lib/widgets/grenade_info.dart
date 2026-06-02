import 'package:flutter/material.dart';
import '../core/models/grenade.dart';
import '../core/models/grenade_origin.dart';
import '../core/utils/side_describing.dart';
import 'image_viewer_dialog.dart';

class GrenadeInfoSheet extends StatelessWidget {
  const GrenadeInfoSheet(this.grenade, this.origin, {super.key});

  final GrenadeOrigin origin;
  final Grenade grenade;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .all(16),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Row(
            spacing: 6,
            children: [
              _TagChip(origin.throwType.describe()),
              _TagChip(origin.side.describe()),
            ],
          ),
          if (grenade.description != null) Text(grenade.description!),
          if (origin.description != null) Text(origin.description!),
          // Text(origin.throwType.describe()),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 1.33,
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemCount: origin.images.length,
            itemBuilder: (context, idx) => GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    ImageViewerDialog(origin: origin, index: idx),
              ),
              child: Container(
                decoration: BoxDecoration(borderRadius: .circular(8)),
                clipBehavior: .antiAlias,
                child: Image(image: origin.images[idx].image),
              ),
            ),
          ),
          // ...origin.images.map((e) => Image(image: e.image)),
        ],
      ),
    ),
  );
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Chip(
    padding: .zero,
    label: Text(text, style: const .new(fontSize: 13)),
  );
}

extension on ThrowType {
  String describe() => switch (this) {
    .crouch => 'Бросать в приседе',
    .jump => 'Бросать в прижке',
    .run => 'Бросать в беге',
    .runAndJump => 'Бросать прыгнув в беге',
    .stand => 'Бросать стоя',
  };
}
