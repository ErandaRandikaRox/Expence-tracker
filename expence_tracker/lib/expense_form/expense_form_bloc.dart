import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:expense_tracker/models/expence.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  ExpenseFormBloc({
    required ExpenceReporsitory repository,
    required BuildContext context,
    Expence? initialExpence,
  }) : _repository = repository,
       _context = context,
       super(
         ExpenseFormState(
           initialExpence: initialExpence,
           title: initialExpence?.title ?? '',
           amount: initialExpence?.amount ?? 0.0,
           date: initialExpence?.date ?? DateTime.now(),
           catergory: initialExpence?.catergory ?? Catergory.other,
           isFormValid: _isFormValid(
             initialExpence?.title ?? '',
             initialExpence?.amount ?? 0.0,
             initialExpence?.catergory ?? Catergory.other,
             initialExpence?.date ?? DateTime.now(),
           ),
         ),
       ) {
    on<ExpenseTitleChanged>(_onTitleChanged);
    on<ExpenseAmountChanged>(_onAmountChanged);
    on<ExpenseDateChanged>(_onDateChanged);
    on<ExpenseCategoryChanged>(_onCategoryChanged);
    on<ExpenseFormSubmitted>(_onSubmitted);
  }

  final ExpenceReporsitory _repository;
  final BuildContext _context;

  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(
      title: event.title,
      isFormValid: _isFormValid(event.title, state.amount, state.catergory, state.date),
    ));
  }

  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(
      amount: event.amount,
      isFormValid: _isFormValid(state.title, event.amount, state.catergory, state.date),
    ));
  }

  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(
      date: event.date,
      isFormValid: _isFormValid(state.title, state.amount, state.catergory, event.date),
    ));
  }

  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(
      catergory: event.catergory,
      isFormValid: _isFormValid(state.title, state.amount, event.catergory, state.date),
    ));
  }

  Future<void> _onSubmitted(
    ExpenseFormSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          errorMessage: 'Please fill all fields correctly (title, amount > 0, category, date).',
        ),
      );
      return;
    }

    final expense = (state.initialExpence)?.copyWith(
          id: state.initialExpence!.id,
          title: state.title!,
          amount: state.amount!,
          date: state.date!,
          catergory: state.catergory!,
        ) ??
        Expence(
          id: const Uuid().v4(),
          title: state.title!,
          amount: state.amount!,
          date: state.date!,
          catergory: state.catergory!,
        );

    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      if (state.initialExpence != null) {
        await _repository.updateExpense(expense);
        _context.read<ExpenseListBloc>().add(ExpenseListExpenseUpdated(expense));
      } else {
        await _repository.createExpence(expense);
        _context.read<ExpenseListBloc>().add(ExpenseListExpenseAdded(expense));
      }
      emit(
        state.copyWith(
          status: ExpenseFormStatus.success,
          initialExpence: null,
          title: '',
          amount: 0.0,
          date: DateTime.now(),
          catergory: Catergory.other,
          isFormValid: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          errorMessage: 'Failed to save expense: $e',
        ),
      );
    }
  }

  static bool _isFormValid(String? title, double? amount, Catergory? catergory, DateTime? date) {
    return title != null &&
        title.isNotEmpty &&
        amount != null &&
        amount > 0 &&
        catergory != null &&
        catergory != Catergory.all &&
        date != null;
  }
}