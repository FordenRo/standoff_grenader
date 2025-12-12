import 'package:flutter/material.dart';
import 'package:standoff_grenader/config.dart' show CMap, Grenade;
import 'package:standoff_grenader/widgets/grenade.dart'
    show GrenadeOriginWidget, GrenadeWidget;

class MapPage extends StatefulWidget {
  final CMap map;

  const MapPage(this.map, {super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Grenade? selectedGrenade;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> children = .of(
      (selectedGrenade == null ? widget.map.grenades : [selectedGrenade!]).map(
        (e) => GrenadeWidget(
          e,
          onPressed: () => setState(
            () => selectedGrenade = selectedGrenade == null ? e : null,
          ),
        ),
      ),
    );

    if (selectedGrenade != null) {
      children.addAll(
        selectedGrenade!.origins
            .map(
              (e) => GrenadeOriginWidget(
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
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.map.name),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: InteractiveViewer(
        maxScale: 4,
        child: GestureDetector(
          onTapDown: (details) {
            print(details.localPosition);
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: widget.map.image),
            ),
            child: PopScope(
              canPop: selectedGrenade == null,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  setState(() => selectedGrenade = null);
                }
              },
              child: Stack(children: children),
            ),
          ),
        ),
      ),
    );
  }
}
