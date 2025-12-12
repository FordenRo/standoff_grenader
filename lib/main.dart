import 'package:flutter/material.dart';
import 'package:standoff_grenader/config.dart' show loadConfig;
import 'package:standoff_grenader/pages/map_list_page.dart' show MapListPage;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Standoff Grenader',
    theme: ThemeData(
      colorScheme: .fromSeed(seedColor: Colors.purple, brightness: .dark),
      useMaterial3: true,
    ),
    home: FutureBuilder(
      future: loadConfig(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MapListPage(maps: snapshot.requireData.maps);
        } else if (snapshot.hasError) {
          // TODO: Error page
          return Text('Error: ${snapshot.error}');
        }
        // TODO: Make it look good
        return const CircularProgressIndicator();
      },
    ),
  );
}
