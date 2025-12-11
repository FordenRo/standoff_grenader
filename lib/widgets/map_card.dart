import 'package:flutter/material.dart';
import 'package:standoff_grenader/pages/map_page.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => MapPage()));
        },
        child: Padding(padding: .all(15), child: Text('test')),
      ),
    );
  }
}
