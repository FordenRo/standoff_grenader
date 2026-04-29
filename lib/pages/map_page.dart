import 'package:flutter/material.dart';
import '../database.dart';
import '../widgets/grenade.dart';
import '../widgets/grenade_info.dart';

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

    final children = List<Widget>.of(
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
                    builder: (context) => GrenadeInfoSheet(selectedGrenade!, e),
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
      body: FutureBuilder(
        future: widget.map.image.image,
        builder: (context, snapshot) => snapshot.hasData
            ? InteractiveViewer(
                maxScale: 4,
                child: GestureDetector(
                  onTapDown: (details) {
                    print(details.localPosition);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: snapshot.requireData),
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
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
