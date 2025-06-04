part of 'expense_form_bloc.dart';

enum ExpenseFormStatus { initial, loading, success, failure }

class ExpenseFormState extends Equatable {
  const ExpenseFormState({
    this.initialExpence,
    this.title = '',
    this.amount = 0.0,
    this.date,
    this.catergory = Catergory.other,
    this.status = ExpenseFormStatus.initial,
    this.errorMessage,
    this.isFormValid = false,
  });

  final Expence? initialExpence;
  final String title;
  final double amount;
  final DateTime? date;
  final Catergory catergory;
  final ExpenseFormStatus status;
  final String? errorMessage;
  final bool isFormValid;

  ExpenseFormState copyWith({
    Expence? initialExpence,
    String? title,
    double? amount,
    DateTime? date,
    Catergory? catergory,
    ExpenseFormStatus? status,
    String? errorMessage,
    bool? isFormValid,
  }) {
    return ExpenseFormState(
      initialExpence: initialExpence ?? this.initialExpence,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      catergory: catergory ?? this.catergory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        initialExpence,
        title,
        amount,
        date,
        catergory,
        status,
        errorMessage,
        isFormValid,
      ];
}