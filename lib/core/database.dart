import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'models/map_model.dart';

class DbImage {
  DbImage(this.path);

  final String path;
  ImageProvider? _image;

  ImageProvider get image => _image ??= FileImage(
    File('${Database.instance!.directory.path}/images/$path'),
  );
}

class Database {
  Database._({required this.directory});

  static Database? instance;

  final Directory directory;
  late final file = File('${directory.path}/database.json');
  late final _versionFile = File('${directory.path}/version.txt');
  List<MapModel> maps = [];

  static Future<Database> load() async {
    final db = Database._(
      directory: kDebugMode
          ? Directory.current
          : Directory((await getApplicationSupportDirectory()).path),
    );
    await db._load();
    instance = db;
    return db;
  }

  Future<Database> _load() async {
    final directory = kDebugMode
        ? Directory.current
        : Directory((await getApplicationSupportDirectory()).path);
    var hasUpdate = false;
    if (!kDebugMode) {
      final remoteVersion = await http.read(_gitUri('version.txt'));
      if (!_versionFile.existsSync() ||
          remoteVersion != await _versionFile.readAsString()) {
        await _versionFile.writeAsString(remoteVersion);
        hasUpdate = true;
      }
    }

    final content = hasUpdate
        ? await http.read(_gitUri('database.json'))
        : await file.readAsString();

    final data = (jsonDecode(content) as Map).cast<String, dynamic>();
    maps = (data['maps'] as List)
        .cast<Map<String, dynamic>>()
        .map(MapModel.fromMap)
        .toList();

    final extras = <String>[];
    for (final map in maps) {
      for (final grenade in map.grenades) {
        for (final origin in grenade.origins) {
          extras.addAll(origin.images.map((e) => e.path));
        }
      }
    }

    if (hasUpdate) {
      await Future.wait([
        file.writeAsString(content),
        ...maps.map((e) => _createAndWrite(e.image.path)),
        ...maps.map((e) => _createAndWrite(e.cover.path)),
        ...extras.map(_createAndWrite),
      ]);
    }

    return Database._(directory: directory);
  }

  Future<void> _createAndWrite(String path) async {
    final file = File('${directory.path}/images/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(await http.readBytes(_gitUri('images/$path')));
  }
}

Uri _gitUri(String path) => Uri.https(
  'raw.githubusercontent.com',
  '/FordenRo/standoff_grenader/refs/heads/main/$path',
);
