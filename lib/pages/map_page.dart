import 'package:flutter/material.dart';
import 'package:standoff_grenader/config.dart' show CMap;
import 'package:standoff_grenader/widgets/grenade.dart' show GrenadeWidget;

class MapPage extends StatelessWidget {
  final CMap map;

  const MapPage(this.map, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(map.name),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: InteractiveViewer(
        child: Container(
          decoration: BoxDecoration(color: Colors.red),
          child: Stack(
            children: map.grenades
                .map(
                  (e) => GrenadeWidget(
                    e,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(height: 200),
                      );
                    },
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
