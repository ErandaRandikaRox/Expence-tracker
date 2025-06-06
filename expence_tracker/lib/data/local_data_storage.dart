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
  
  // Fixed: Use non-nullable list
  final _controller = BehaviorSubject<List<Expence>>.seeded(const []);

  void initialize() {
    final expenceJson = _preferences.getString(expenseCollectionKey);
    print('Initializing storage. Found data: ${expenceJson != null}');
    
    if (expenceJson != null) {
      try {
        final expenceList = List<dynamic>.from(jsonDecode(expenceJson) as List);
        final expences = expenceList
            .map((expense) => Expence.fromJson(expense as Map<String, dynamic>))
            .toList();
        _controller.add(expences);
        print('Loaded ${expences.length} expenses from storage');
      } catch (e) {
        print('Error loading expenses: $e');
        _controller.add(const []);
      }
    } else {
      print('No existing data found, starting with empty list');
      _controller.add(const []);
    }
  }

  // Fixed: Return non-nullable list
  Stream<List<Expence>> getExpences() => _controller.asBroadcastStream();

  Future<void> saveExpences(Expence expense) async {
    print('Saving expense: ${expense.title} - \$${expense.amount}');
    
    try {
      final expences = List<Expence>.from(_controller.value);
      final expencesIndex = expences.indexWhere(
        (currentExpence) => currentExpence.id == expense.id,
      );

      if (expencesIndex >= 0) {
        expences[expencesIndex] = expense;
        print('Updated existing expense at index $expencesIndex');
      } else {
        expences.add(expense);
        print('Added new expense. Total count: ${expences.length}');
      }

      // Update the stream controller
      _controller.add(expences);

      // Save to SharedPreferences
      final jsonData = expences.map((e) => e.toJson()).toList();
      final jsonString = jsonEncode(jsonData);
      
      print('Saving JSON: $jsonString');
      
      final success = await _preferences.setString(expenseCollectionKey, jsonString);
      
      if (success) {
        print('Successfully saved to SharedPreferences');
        
        // Verify the save by reading it back
        final verification = _preferences.getString(expenseCollectionKey);
        print('Verification read: ${verification != null ? "Success" : "Failed"}');
      } else {
        throw Exception('SharedPreferences.setString returned false');
      }
    } catch (e) {
      print('Error in saveExpences: $e');
      rethrow;
    }
  }

  Future<void> deleteExpences(Expence expense) async {
    print('Deleting expense: ${expense.title}');
    
    try {
      final expences = List<Expence>.from(_controller.value);
      final expencesIndex = expences.indexWhere(
        (currentExpence) => currentExpence.id == expense.id,
      );

      if (expencesIndex < 0) {
        throw Exception('No expense found with id: ${expense.id}');
      }

      expences.removeAt(expencesIndex);
      _controller.add(expences);

      final jsonData = expences.map((e) => e.toJson()).toList();
      final jsonString = jsonEncode(jsonData);
      
      final success = await _preferences.setString(expenseCollectionKey, jsonString);
      
      if (success) {
        print('Successfully deleted expense');
      } else {
        throw Exception('Failed to save after deletion');
      }
    } catch (e) {
      print('Error in deleteExpences: $e');
      rethrow;
    }
  }

  void dispose() {
    _controller.close();
  }
}