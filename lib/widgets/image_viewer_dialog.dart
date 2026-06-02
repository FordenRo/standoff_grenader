import 'package:flutter/material.dart';

import '../core/models/grenade_origin.dart';

class ImageViewerDialog extends StatelessWidget {
  const ImageViewerDialog({
    required this.origin,
    required this.index,
    super.key,
  });

  final GrenadeOrigin origin;
  final int index;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const .all(64),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8),
          side: .new(
            color: Theme.of(context).colorScheme.primary.withAlpha(100),
          ),
        ),
        child: Padding(
          padding: const .all(8),
          child: Container(
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(borderRadius: .circular(6)),
            child: InteractiveViewer(
              child: Image(image: origin.images[index].image),
            ),
          ),
        ),
      ),
    ),
  );
}
