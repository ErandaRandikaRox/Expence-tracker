// data/local_data_storage.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/models/expence.dart';

class LocalDataStorage {
  static const String _expensesKey = 'expenses_list';
  
  // StreamController to manage the expenses stream
  final StreamController<List<Expence>> _expensesController = 
      StreamController<List<Expence>>.broadcast();
  
  // In-memory cache of expenses
  List<Expence> _expenses = [];
  
  // Initialize flag to ensure we only load once
  bool _isInitialized = false;
  
  // Constructor - automatically initialize data
  LocalDataStorage({required SharedPreferences preferences}) {
    _initializeData();
  }
  
  // Initialize data from SharedPreferences
  Future<void> _initializeData() async {
    if (_isInitialized) return;
    
    try {
      print('Initializing storage...');
      final prefs = await SharedPreferences.getInstance();
      final String? expensesJson = prefs.getString(_expensesKey);
      
      if (expensesJson != null && expensesJson.isNotEmpty) {
        print('Found existing data: $expensesJson');
        final List<dynamic> expensesList = json.decode(expensesJson);
        _expenses = expensesList.map((json) => Expence.fromJson(json)).toList();
        print('Loaded ${_expenses.length} expenses from storage');
      } else {
        print('No existing data found, starting with empty list');
        _expenses = [];
      }
      
      _isInitialized = true;
      _expensesController.add(_expenses); // Emit initial data
      
    } catch (e) {
      print('Error initializing data: $e');
      _expenses = [];
      _isInitialized = true;
      _expensesController.add(_expenses);
    }
  }
  
  // Get expenses as a stream
  Stream<List<Expence>> getExpences() {
    // Ensure initialization before returning stream
    if (!_isInitialized) {
      _initializeData();
    }
    return _expensesController.stream;
  }
  
  // Save a new expense or update existing one
  Future<void> saveExpences(Expence expence) async {
    await _ensureInitialized();
    
    try {
      print('Saving expense: ${expence.title} - \$${expence.amount}');
      
      // Check if expense already exists (by id)
      final existingIndex = _expenses.indexWhere((e) => e.id == expence.id);
      
      if (existingIndex != -1) {
        // Update existing expense
        _expenses[existingIndex] = expence;
        print('Updated existing expense at index $existingIndex');
      } else {
        // Add new expense
        _expenses.add(expence);
        print('Added new expense. Total count: ${_expenses.length}');
      }
      
      // Save to SharedPreferences
      await _saveToPreferences();
      
      // Emit updated list
      _expensesController.add(List.from(_expenses));
      
    } catch (e) {
      print('Error saving expense: $e');
      rethrow;
    }
  }
  
  // Delete an expense
  Future<void> deleteExpences(Expence expence) async {
    await _ensureInitialized();
    
    try {
      print('Deleting expense: ${expence.title}');
      
      _expenses.removeWhere((e) => e.id == expence.id);
      print('Expense deleted. Remaining count: ${_expenses.length}');
      
      // Save to SharedPreferences
      await _saveToPreferences();
      
      // Emit updated list
      _expensesController.add(List.from(_expenses));
      
    } catch (e) {
      print('Error deleting expense: $e');
      rethrow;
    }
  }
  
  // Get current expenses list (synchronous)
  List<Expence> getCurrentExpenses() {
    return List.from(_expenses);
  }
  
  // Private method to save to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String expensesJson = json.encode(
        _expenses.map((expense) => expense.toJson()).toList()
      );
      
      print('Saving JSON: $expensesJson');
      
      final bool result = await prefs.setString(_expensesKey, expensesJson);
      
      if (result) {
        print('Successfully saved to SharedPreferences');
        
        // Verification read
        final String? verification = prefs.getString(_expensesKey);
        if (verification != null) {
          print('Verification read: Success');
        } else {
          print('Verification read: Failed - data not found');
        }
      } else {
        print('Failed to save to SharedPreferences');
      }
    } catch (e) {
      print('Error saving to preferences: $e');
      rethrow;
    }
  }
  
  // Ensure data is initialized before operations
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeData();
    }
  }
  
  // Debug method to check storage
  Future<void> debugStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('All SharedPreferences keys: $keys');
    
    final data = prefs.getString(_expensesKey);
    print('Expenses data: $data');
  }
  
  // Clean up resources
  void dispose() {
    _expensesController.close();
  }
}