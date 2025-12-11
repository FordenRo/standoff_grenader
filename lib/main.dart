import 'package:flutter/material.dart';
import 'package:standoff_grenader/pages/map_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.purple, brightness: .dark),
        useMaterial3: true,
      ),
      home: const MapListPage(),
    );
  }
}
