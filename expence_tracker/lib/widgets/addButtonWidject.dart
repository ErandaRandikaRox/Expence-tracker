import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<ExpenseFormBloc>().state;
    
    final isLoading = state.status == ExpenseFormStatus.loading;
    final isFormValid = state.isFormValid;
    final isEnabled = !isLoading && isFormValid;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Show validation status for debugging
        if (!isFormValid && !isLoading)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              _getValidationMessage(state),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        FilledButton(
          onPressed: isEnabled
              ? () {
                  context.read<ExpenseFormBloc>().add(const ExpenseFormSubmitted());
                }
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: isEnabled 
                ? theme.colorScheme.primary 
                : theme.colorScheme.surfaceVariant,
            foregroundColor: isEnabled 
                ? theme.colorScheme.onPrimary 
                : theme.colorScheme.onSurfaceVariant,
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(state.initialExpence != null ? 'Update Expense' : 'Add Expense'),
        ),
      ],
    );
  }

  String _getValidationMessage(ExpenseFormState state) {
    final List<String> issues = [];
    
    if (state.title.isEmpty) issues.add('Title required');
    if (state.amount <= 0) issues.add('Amount must be > 0');
    if (state.catergory == Catergory.all) issues.add('Select category');
    if (state.date == null) issues.add('Date required');
    
    return 'Missing: ${issues.join(', ')}';
  }
}