part of 'expence_list_bloc.dart';

enum ExpenseListStatus { initial, loading, failed, success }

class ExpenseListState extends Equatable {
  final List<Expence> expenses;
  final ExpenseListStatus status;
  final double totalExpenses;
  final Catergory filter;
  Iterable<Expence> get filteredExpences => filter.applyAll(expenses);

  const ExpenseListState({
    this.expenses = const [],
    this.status = ExpenseListStatus.initial,
    this.totalExpenses = 0.0,
    this.filter = Catergory.all,
  });

  ExpenseListState copyWith({
    List<Expence>? expenses,
    ExpenseListStatus? status,
    double? totalExpenses,
    Catergory? filter,
  }) {
    return ExpenseListState(
      expenses: expenses ?? this.expenses,
      status: status ?? this.status,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      filter: filter ?? this.filter,
    );
  }

  factory ExpenseListState.initial() => const ExpenseListState();

  @override
  List<Object?> get props => [expenses, status, totalExpenses, filter];
}