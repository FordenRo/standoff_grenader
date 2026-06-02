import 'package:flutter/material.dart';

import '../core/models/map_model.dart';
import '../widgets/map_card.dart';

class MapListPage extends StatelessWidget {
  const MapListPage({required this.maps, super.key});

  final List<MapModel> maps;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 140,
      ),
      itemCount: maps.length,
      itemBuilder: (context, index) => MapCard(maps[index]),
      padding: const .all(10),
    ),
  );
}
