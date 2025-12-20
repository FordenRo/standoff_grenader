import 'package:flutter/material.dart';
import 'package:standoff_grenader/widgets/map_card.dart' show MapCard;
import 'package:standoff_grenader/database.dart' show CMap;

class MapListPage extends StatelessWidget {
  final List<CMap> maps;

  const MapListPage({super.key, required this.maps});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Standoff Grenader'),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: SingleChildScrollView(
        padding: .all(10),
        child: Column(
          spacing: 5,
          crossAxisAlignment: .stretch,
          children: maps.map(MapCard.new).toList(growable: false),
        ),
      ),
    );
  }
}
