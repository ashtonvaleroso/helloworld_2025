import 'package:flutter/material.dart';
import 'package:helloworld_2025/global_variables.dart';
import 'package:helloworld_2025/objectbox/objectbox_manager.dart';
import 'package:helloworld_2025/objectbox/repository.dart';

Future<void> initMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGlobalVariables();
}

Future<void> initGlobalVariables() async {
  final store = await ObjectBoxManager.getStore();
  repository = Repository(store);
}
