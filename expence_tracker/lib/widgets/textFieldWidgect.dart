import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldWidgect extends StatelessWidget {
  TextFieldWidgect({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme = Theme.of(context).textTheme;
    final state = context.watch<ExpenseFormBloc>().state;
    return TextFormField(
      style: TextTheme.displaySmall?.copyWith(fontSize: 16),
      onChanged: (value) {
        context.read<ExpenseFormBloc>().add(ExpenseTitleChanged(value));
      },
      decoration: InputDecoration(
        enabled: state.status != ExpenseFormStatus.loading,
        border: InputBorder.none,
        hintText: 'Expence title',
      ),
    );
  }
}
