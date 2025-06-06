import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmountFieldWidget extends StatelessWidget {
  const AmountFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<ExpenseFormBloc>().state;
    
    return TextFormField(
      style: textTheme.displaySmall?.copyWith(fontSize: 16),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      initialValue: state.amount > 0 ? state.amount.toString() : '',
      onChanged: (value) {
        final amount = double.tryParse(value) ?? 0.0;
        context.read<ExpenseFormBloc>().add(ExpenseAmountChanged(amount));
      },
      decoration: InputDecoration(
        enabled: state.status != ExpenseFormStatus.loading,
        border: InputBorder.none,
        hintText: 'Expense amount', // Changed from 'Expence title' to reflect amount field
      ),
    );
  }
}