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
    required ExpenceRepository repository, // Fixed: Consistent naming
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

  final ExpenceRepository _repository; // Fixed: Consistent naming
  final BuildContext _context;

  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    print('Title changed to: ${event.title}');
    emit(state.copyWith(
      title: event.title,
      isFormValid: _isFormValid(event.title, state.amount, state.catergory, state.date),
    ));
  }

  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    print('Amount changed to: ${event.amount}');
    emit(state.copyWith(
      amount: event.amount,
      isFormValid: _isFormValid(state.title, event.amount, state.catergory, state.date),
    ));
  }

  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    print('Date changed to: ${event.date}');
    emit(state.copyWith(
      date: event.date,
      isFormValid: _isFormValid(state.title, state.amount, state.catergory, event.date),
    ));
  }

  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    print('Category changed to: ${event.catergory}');
    emit(state.copyWith(
      catergory: event.catergory,
      isFormValid: _isFormValid(state.title, state.amount, event.catergory, state.date),
    ));
  }

  Future<void> _onSubmitted(
    ExpenseFormSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    print('Form submitted. Valid: ${state.isFormValid}');
    print('Title: "${state.title}", Amount: ${state.amount}, Category: ${state.catergory}, Date: ${state.date}');
    
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
          title: state.title,
          amount: state.amount,
          date: state.date!,
          catergory: state.catergory,
        ) ??
        Expence(
          id: const Uuid().v4(),
          title: state.title,
          amount: state.amount,
          date: state.date!,
          catergory: state.catergory,
        );

    print('Created expense object: ${expense.toJson()}');
    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      if (state.initialExpence != null) {
        print('Updating existing expense');
        await _repository.updateExpense(expense);
        if (_context.mounted) {
          _context.read<ExpenseListBloc>().add(ExpenseListExpenseUpdated(expense));
        }
      } else {
        print('Creating new expense');
        await _repository.createExpence(expense);
        if (_context.mounted) {
          _context.read<ExpenseListBloc>().add(AddExpenseEvent(expense));
        }
      }
      
      print('Successfully saved expense');
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
      print('Error saving expense: $e');
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          errorMessage: 'Failed to save expense: $e',
        ),
      );
    }
  }

  static bool _isFormValid(String? title, double? amount, Catergory? catergory, DateTime? date) {
    final valid = title != null &&
        title.isNotEmpty &&
        amount != null &&
        amount > 0 &&
        catergory != null &&
        catergory != Catergory.all &&
        date != null;
    
    print('Form validation: $valid (title: $title, amount: $amount, category: $catergory, date: $date)');
    return valid;
  }
}