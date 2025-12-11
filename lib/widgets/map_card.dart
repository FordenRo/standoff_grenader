import 'package:flutter/material.dart';
import 'package:standoff_grenader/pages/map_page.dart' show MapPage;
import 'package:standoff_grenader/config.dart' show CMap;

class MapCard extends StatelessWidget {
  final CMap map;

  const MapCard(this.map, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => MapPage(map)));
        },
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: map.cover)),
          child: Padding(padding: .all(15), child: Text(map.name)),
        ),
      ),
    );
  }
}
