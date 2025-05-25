import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/util/format_total_expences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalExpenseWidget extends StatelessWidget {
  const TotalExpenseWidget({super.key, required double totalAmount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final state = context.watch<ExpenseListBloc>().state;
    final totalExpense = formatTotalExpences(state.totalExpenses);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total expense value',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.4),
            ),
          ),
          Text(
            totalExpense,
            style: theme.textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}