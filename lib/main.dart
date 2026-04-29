import 'package:flutter/material.dart';
import 'database.dart';
import 'pages/map_list_page.dart';

late Database database;

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
      future: loadDatabase(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          database = snapshot.requireData;

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
