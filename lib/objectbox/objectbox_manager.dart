import 'package:flutter/material.dart';
import 'package:helloworld_2025/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ObjectBoxManager {
  static Store? _store;

  static Future<Store> getStore() async {
    if (_store != null) return _store!;

    final appDocDir = await getApplicationDocumentsDirectory();
    final storePath = p.join(appDocDir.path, "objectbox");

    try {
      if (Store.isOpen(storePath)) {
        print('Store already open');
        _store = Store.attach(getObjectBoxModel(), storePath);
      } else {
        print('Opening new store at $storePath');
        _store = openStore(directory: storePath);
      }
    } catch (e) {
      debugPrint("Error opening store at $storePath: $e");
      rethrow;
    }

    return _store!;
  }
}
