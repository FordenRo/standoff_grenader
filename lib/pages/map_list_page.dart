import 'package:flutter/material.dart';
import 'package:standoff_grenader/widgets/map_card.dart';

class MapListPage extends StatelessWidget {
  const MapListPage({super.key});

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
          children: List.filled(5, MapCard()),
        ),
      ),
    );
  }
}
