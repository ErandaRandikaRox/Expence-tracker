import 'dart:convert';

import 'package:expense_tracker/models/expence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class LocalDataStorage {
  LocalDataStorage({required SharedPreferences preferences})
      : _preferences = preferences {
    initialize();
  }

  final SharedPreferences _preferences;

  static const expenseCollectionKey = 'Expence_collection_key';

  final _controller = BehaviorSubject<List<Expence?>>.seeded(const []);

  void initialize() {
    final expencejson = _preferences.getString(expenseCollectionKey);
    if (expencejson != null) {
      final expenceList = List<dynamic>.from(jsonDecode(expencejson) as List);
      final expences =
          expenceList.map((expense) => Expence.fromJson(expense)).toList();
      _controller.add(expences);
    } else {
      _controller.add(const []);
    }
  }

  Stream<List<Expence?>> getExpences() => _controller.asBroadcastStream();

  Future<void> saveExpences(Expence expense) async {
    final expences = [..._controller.value];
    final expencesIndex = expences.indexWhere(
      (currentExpences) => currentExpences?.id == expense.id,
    );

    if (expencesIndex >= 0) {
      expences[expencesIndex] = expense;
    } else {
      expences.add(expense);
    }
    _controller.add(expences);
    await _preferences.setString(
        expenseCollectionKey, jsonEncode(expences.map((e) => e!.toJson()).toList()));
    return;
  }

  Future<void> deleteExpences(Expence expense) async {
    final expences = [..._controller.value];
    final expencesIndex = expences.indexWhere(
      (currentExpences) => currentExpences?.id == expense.id,
    );

    if (expencesIndex < 0) {
      throw Exception('No expense found');
    } else {
      expences.removeAt(expencesIndex);
      _controller.add(expences);
      await _preferences.setString(
          expenseCollectionKey, jsonEncode(expences.map((e) => e!.toJson()).toList()));
    }
  }
}