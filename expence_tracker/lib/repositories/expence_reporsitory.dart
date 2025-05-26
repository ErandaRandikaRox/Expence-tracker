import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/models/expence.dart';

class ExpenceReporsitory {
  const ExpenceReporsitory({required LocalDataStorage storage})
      : _storage = storage;
  final LocalDataStorage _storage;

  Future<void> createExpence(Expence expence) => _storage.saveExpences(expence);

  Future<void> deleteExpense(Expence expence) => _storage.deleteExpences(expence); // Corrected typo

  Stream<List<Expence?>> getAllExpences() => _storage.getExpences();

  Future<void> addExpense(Expence expence) => createExpence(expence); // Implemented
}