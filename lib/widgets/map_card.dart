import 'package:flutter/material.dart';

import '../core/models/map_model.dart';
import '../pages/map_page.dart' show MapPage;

class MapCard extends StatelessWidget {
  const MapCard(this.map, {super.key});

  final MapModel map;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: .hardEdge,
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapPage(map)),
      ),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: map.cover.image,
            fit: .cover,
            opacity: 0.7,
          ),
        ),
        child: Center(
          child: Text(
            map.name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
