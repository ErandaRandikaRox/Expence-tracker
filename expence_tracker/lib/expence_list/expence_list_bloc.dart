import 'package:bloc/bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:expense_tracker/models/expence.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'expence_list_event.dart';
part 'expence_list_state.dart';

class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  final ExpenceReporsitory repository;

  ExpenseListBloc({required ExpenceReporsitory repository}) // Fix: Changed 'ekspence_reporsitory' to 'ExpenceReporsitory'
      : repository = repository,
        super(const ExpenseListState()) {
    on<ExpenseListSubscriptionRequested>(_onSubscriptionRequested);
    on<ExpenseListExpenseDeleted>(_onExpenseDeleted);
    on<ExpenseListCategoryRequired>(_onExpenseCategoryFilterChanged);
    on<AddExpenseEvent>(_onExpenseAdded);
    on<ExpenseListExpenseUpdated>(_onExpenseUpdated);
  }

  Future<void> _onSubscriptionRequested(
    ExpenseListSubscriptionRequested event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseListStatus.loading));

    final stream = repository.getAllExpences();

    await emit.forEach(stream, onData: (List<Expence?> expenses) {
      final nonNullExpenses = expenses.where((expense) => expense != null).cast<Expence>().toList();
      final totalExpenses = nonNullExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      return state.copyWith(
        status: ExpenseListStatus.success,
        expenses: nonNullExpenses,
        totalExpenses: totalExpenses,
      );
    });
  }

  Future<void> _onExpenseDeleted(
    ExpenseListExpenseDeleted event,
    Emitter<ExpenseListState> emit,
  ) async {
    try {
      await repository.deleteExpense(event.expense);
      final updatedExpenses = state.expenses.where((e) => e.id != event.expense.id).toList();
      final totalExpenses = updatedExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      emit(state.copyWith(
        expenses: updatedExpenses,
        totalExpenses: totalExpenses,
        status: ExpenseListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExpenseListStatus.failed));
    }
  }

  Future<void> _onExpenseCategoryFilterChanged(
    ExpenseListCategoryRequired event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(filter: event.category));
  }

  Future<void> _onExpenseAdded(
    AddExpenseEvent event,
    Emitter<ExpenseListState> emit,
  ) async {
    try {
      await repository.addExpense(event.expense);
      final updatedExpenses = [...state.expenses, event.expense];
      final totalExpenses = updatedExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      emit(state.copyWith(
        expenses: updatedExpenses,
        totalExpenses: totalExpenses,
        status: ExpenseListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExpenseListStatus.failed));
    }
  }

  Future<void> _onExpenseUpdated(
    ExpenseListExpenseUpdated event,
    Emitter<ExpenseListState> emit,
  ) async {
    try {
      await repository.updateExpense(event.expense);
      final updatedExpenses = state.expenses.map((e) {
        return e.id == event.expense.id ? event.expense : e;
      }).toList();
      final totalExpenses = updatedExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
      emit(state.copyWith(
        expenses: updatedExpenses,
        totalExpenses: totalExpenses,
        status: ExpenseListStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: ExpenseListStatus.failed));
    }
  }
}