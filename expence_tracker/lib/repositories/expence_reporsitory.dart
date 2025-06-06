import 'package:expense_tracker/data/local_data_storage.dart';
import 'package:expense_tracker/models/expence.dart';

class ExpenceRepository {
  const ExpenceRepository({required LocalDataStorage storage})
      : _storage = storage;
      
  final LocalDataStorage _storage;

  Future<void> createExpence(Expence expence) async {
    print('Repository: Creating expense - ${expence.title}, Amount: ${expence.amount}');
    await _storage.saveExpences(expence);
  }

  Future<void> deleteExpense(Expence expence) async {
    print('Repository: Deleting expense - ${expence.title}');
    await _storage.deleteExpences(expence);
  }

  // Fixed: Return non-nullable list
  Stream<List<Expence>> getAllExpences() => _storage.getExpences();

  Future<void> addExpense(Expence expence) => createExpence(expence);

  Future<void> updateExpense(Expence expence) async {
    print('Repository: Updating expense - ${expence.title}');
    await _storage.saveExpences(expence);
  }
}