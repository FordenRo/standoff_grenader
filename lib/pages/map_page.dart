import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

import '../core/models/grenade.dart';
import '../core/models/grenade_origin.dart';
import '../core/models/map_model.dart';
import '../core/utils/side_describing.dart';
import '../widgets/grenade_button.dart';
import '../widgets/grenade_info.dart';

class MapPage extends StatefulWidget {
  const MapPage(this.map, {super.key});

  final MapModel map;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final StreamController<double> scaleBroadcast = .broadcast();
  late final StreamSubscription scaleSub;
  late final TransformationController controller = .new()
    ..addListener(
      () => scaleBroadcast.add(controller.value.getMaxScaleOnAxis()),
    );
  Grenade? selectedGrenade;
  Side selectedSide = .both;
  GrenadeType? selectedType;
  var scale = 1.0;

  @override
  void initState() {
    super.initState();
    scaleSub = scaleBroadcast.stream.distinct().listen(
      (scale) => setState(() => this.scale = scale),
    );
    _toCenter();
  }

  @override
  void dispose() {
    scaleSub.cancel();
    controller.dispose();
    scaleBroadcast.close();
    super.dispose();
  }

  void _toCenter() => Future.microtask(() {
    final context = this.context;
    if (!context.mounted) return;

    final scale = min(context.size!.width, context.size!.height) / 1000;
    controller.value = .compose(
      Vector3(
        (context.size!.width - 1000 * scale) / 2,
        (context.size!.height - 1000 * scale) / 2,
        0,
      ),
      .identity(),
      .all(scale),
    );
  });

  void _onGrenadePressed(Grenade grenade) => setState(
    () => selectedGrenade = selectedGrenade != grenade ? grenade : null,
  );

  void _onGrenadeOriginPressed(GrenadeOrigin origin) => showModalBottomSheet(
    context: context,
    builder: (context) => GrenadeInfoSheet(selectedGrenade!, origin),
  );

  List<Widget> _buildGrenades() => selectedGrenade == null
      ? widget.map.grenades
            .where(
              (e) =>
                  selectedSide == .both ||
                  e.side == .both ||
                  e.side == selectedSide,
            )
            .where((e) => selectedType == null || selectedType == e.type)
            .map(
              (e) => GrenadeButton(
                e,
                onPressed: () => _onGrenadePressed(e),
                scale: 1 / scale,
              ),
            )
            .toList()
      : [
          ...selectedGrenade!.origins
              .where(
                (e) =>
                    selectedSide == .both ||
                    e.side == .both ||
                    e.side == selectedSide,
              )
              .map(
                (e) => GrenadeOriginButton(
                  e,
                  onPressed: () => _onGrenadeOriginPressed(e),
                  scale: 1 / scale,
                ),
              ),
          GrenadeButton(
            selectedGrenade!,
            onPressed: () => _onGrenadePressed(selectedGrenade!),
            selected: true,
            scale: 1 / scale,
          ),
        ];

  Stack _buildStack() => Stack(
    children: [
      Image(
        width: 1000,
        height: 1000,
        image: widget.map.image.image,
        fit: .contain,
      ),
      ..._buildGrenades(),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.map.name)),
    body: Stack(children: [_buildMap(), _buildFilterChips()]),
  );

  Widget _buildFilterChips() => Align(
    alignment: .bottomLeft,
    child: Padding(
      padding: const .all(8),
      child: Row(
        spacing: 6,
        children: [
          ActionChip(
            label: Text('Type: ${selectedType?.describe() ?? 'Any'}'),
            onPressed: () => setState(
              () => selectedType = selectedType == null
                  ? .values[0]
                  : selectedType!.index + 1 == GrenadeType.values.length
                  ? null
                  : .values[(selectedType!.index + 1) %
                        GrenadeType.values.length],
            ),
          ),
          ActionChip(
            label: Text('Side: ${selectedSide.describe()}'),
            onPressed: () => setState(
              () => selectedSide =
                  .values[(selectedSide.index + 1) % Side.values.length],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildMap() => NotificationListener(
    onNotification: (notification) {
      if (notification is! SizeChangedLayoutNotification) return false;
      _toCenter();
      return true;
    },
    child: SizeChangedLayoutNotifier(
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox.expand(
          child: InteractiveViewer(
            boundaryMargin: .symmetric(
              horizontal: constraints.maxWidth / 2,
              vertical: constraints.maxHeight / 2,
            ),
            constrained: false,
            minScale: 0.1,
            maxScale: 4,
            scaleFactor: 500,
            transformationController: controller,
            child: PopScope(
              canPop: selectedGrenade == null,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                setState(() => selectedGrenade = null);
              },
              child: FittedBox(
                child: LayoutBuilder(
                  builder: (context, constraints) => kDebugMode
                      ? GestureDetector(
                          onTapDown: (details) => debugPrint(
                            '${details.localPosition.dx.toInt()} / ${details.localPosition.dy.toInt()}',
                          ),
                          child: _buildStack(),
                        )
                      : _buildStack(),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

extension on GrenadeType {
  String describe() => switch (this) {
    .fire => 'Fire',
    .flash => 'Flash',
    .he => 'HE',
    .smoke => 'Smoke',
  };
}
