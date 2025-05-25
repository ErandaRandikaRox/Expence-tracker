import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ExpenseFormBloc>().state;
    return FilledButton(
      onPressed: state.status == ExpenseFormStatus.loading || !state.isFormValid
          ? null
          : () {
              context.read<ExpenseFormBloc>().add(const ExpenseFormSubmitted());
            },
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Add Expense'),
    );
  }
}