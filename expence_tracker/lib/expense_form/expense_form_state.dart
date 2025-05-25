part of 'expense_form_bloc.dart';

enum ExpenseFormStatus { initial, loading, success, failure }

class ExpenseFormState extends Equatable {
  const ExpenseFormState({
    this.title = '',
    this.amount = 0.0,
    this.date,
    this.catergory = Catergory.other,
    this.status = ExpenseFormStatus.initial,
    this.initialExpence,
    this.errorMessage,
  });

  final String title;
  final double amount;
  final DateTime? date;
  final Catergory catergory;
  final ExpenseFormStatus status;
  final Expence? initialExpence;
  final String? errorMessage;

  ExpenseFormState copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Catergory? catergory,
    ExpenseFormStatus? status,
    Expence? initialExpence,
    String? errorMessage,
  }) {
    return ExpenseFormState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      catergory: catergory ?? this.catergory,
      status: status ?? this.status,
      initialExpence: initialExpence ?? this.initialExpence,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isFormValid => title.isNotEmpty && amount > 0 && date != null;

  @override
  List<Object?> get props => [
    title,
    amount,
    date,
    catergory,
    status,
    initialExpence,
    errorMessage,
  ];
}
