import 'package:flutter/material.dart';
import 'package:standoff_grenader/pages/map_page.dart' show MapPage;
import 'package:standoff_grenader/config.dart' show CMap;

class MapCard extends StatelessWidget {
  final CMap map;

  const MapCard(this.map, {super.key});

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: .hardEdge,
    child: InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => MapPage(map)));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(image: map.cover, fit: .cover, opacity: 0.7),
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
