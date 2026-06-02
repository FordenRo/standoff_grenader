import 'dart:async';

import 'package:flutter/material.dart';

class LoadingBuilder<T> extends StatefulWidget {
  const LoadingBuilder({
    required this.future,
    required this.builder,
    super.key,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T result) builder;

  @override
  State<LoadingBuilder<T>> createState() => _LoadingBuilderState<T>();
}

class _LoadingBuilderState<T> extends State<LoadingBuilder<T>>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    duration: const .new(seconds: 1),
  );

  Future<T> start() async {
    await animation.animateTo(1, curve: Curves.easeIn);
    final result = await widget.future;
    await animation.animateBack(0);
    return result;
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: start(),
    builder: (context, snapshot) => snapshot.hasData
        ? widget.builder(context, snapshot.requireData)
        : Scaffold(
            body: Center(
              child: FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      const SizedBox(width: 400, child: Text('test')),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
  );
}
