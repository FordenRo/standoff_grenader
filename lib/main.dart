import 'package:flutter/material.dart';
import 'core/database.dart';
import 'pages/loading_builder.dart';
import 'pages/map_list_page.dart';

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
    home: LoadingBuilder(
      future: Database.load(),
      builder: (context, database) => MapListPage(maps: database.maps),
    ),
  );
}
