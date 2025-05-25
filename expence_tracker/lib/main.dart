import 'package:expense_tracker/app.dart';
import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = LocalDataStorage(
    preferences: await SharedPreferences.getInstance(),
  );

  final expenceReporsitory = ExpenceReporsitory(storage: storage);

  runApp(App(expenceReporsitory:expenceReporsitory));
}
