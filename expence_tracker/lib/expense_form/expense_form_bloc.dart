import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:expense_tracker/models/expence.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:uuid/uuid.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  ExpenseFormBloc({
    required ExpenceReporsitory repository,
    Expence? initialExpence,
  }) : _repository = repository,
       super(
         ExpenseFormState(
           initialExpence: initialExpence,
           title: initialExpence!.title,
           amount: initialExpence.amount,
           date: DateTime.now(),
           catergory: initialExpence.catergory,
         ),
       ) {
    on<ExpenseTitleChanged>(_onTitleChanged);
    on<ExpenseAmountChanged>(_onAmountChanged);
    on<ExpenseDateChanged>(_onDateChanged);
    on<ExpenseCategoryChanged>(_onCategoryChanged);
    on<ExpenseFormSubmitted>(_onSubmitted);
  }

  final ExpenceReporsitory _repository;

  void _onTitleChanged(
    ExpenseTitleChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onAmountChanged(
    ExpenseAmountChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    final amount = double.tryParse(event.amount) ?? 0.0;
    emit(state.copyWith(amount: amount));
  }

  void _onDateChanged(
    ExpenseDateChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _onCategoryChanged(
    ExpenseCategoryChanged event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(catergory: event.catergory));
  }

  Future<void> _onSubmitted(
    ExpenseFormSubmitted event,
    Emitter<ExpenseFormState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          errorMessage: 'Please fill all fields correctly',
        ),
      );
      return;
    }

    final expense =
        (state.initialExpence)?.copyWith(
          id: const Uuid().v4(),
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

    emit(state.copyWith(status: ExpenseFormStatus.loading));

    try {
      await _repository.createExpence(expense);
      emit(
        state.copyWith(
          status: ExpenseFormStatus.success,
          title: '',
          amount: 0.0,
          date: DateTime.now(),
          catergory: Catergory.other,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
