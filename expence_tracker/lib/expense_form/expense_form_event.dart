part of 'expense_form_bloc.dart';

abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object> get props => [];
}

class ExpenseTitleChanged extends ExpenseFormEvent {
  const ExpenseTitleChanged(this.title);
  final String title;

  @override
  List<Object> get props => [title];
}

class ExpenseAmountChanged extends ExpenseFormEvent {
  const ExpenseAmountChanged(this.amount);
  final double amount;

  @override
  List<Object> get props => [amount];
}

class ExpenseDateChanged extends ExpenseFormEvent {
  const ExpenseDateChanged(this.date);
  final DateTime date;

  @override
  List<Object> get props => [date];
}

class ExpenseCategoryChanged extends ExpenseFormEvent {
  const ExpenseCategoryChanged(this.catergory);
  final Catergory catergory;

  @override
  List<Object> get props => [catergory];
}

class ExpenseFormSubmitted extends ExpenseFormEvent {
  const ExpenseFormSubmitted();
}