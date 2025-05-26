part of 'expence_list_bloc.dart';


@immutable@immutable
@immutable
@immutable
sealed class ExpenseListEvent extends Equatable {
  const ExpenseListEvent();

  @override
  List<Object?> get props => [];
}

final class ExpenseListSubscriptionRequested extends ExpenseListEvent {
  const ExpenseListSubscriptionRequested();
}

final class ExpenseListExpenseDeleted extends ExpenseListEvent {
  final Expence expense;

  const ExpenseListExpenseDeleted(this.expense);

  @override
  List<Object> get props => [expense];
}

final class ExpenseListCategoryRequired extends ExpenseListEvent {
  final Catergory category;

  const ExpenseListCategoryRequired(this.category);

  @override
  List<Object> get props => [category];
}

final class AddExpenseEvent extends ExpenseListEvent {
  final Expence expense;

  const AddExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

final class ExpenseListExpenseUpdated extends ExpenseListEvent {
  final Expence expense;

  const ExpenseListExpenseUpdated(this.expense);

  @override
  List<Object> get props => [expense];
}

final class FilterExpenses extends ExpenseListEvent {
  final Catergory? category;

  const FilterExpenses(this.category);

  @override
  List<Object?> get props => [category];
}