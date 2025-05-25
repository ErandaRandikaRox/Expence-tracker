import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/models/expence.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseTitleWidget extends StatelessWidget {
  const ExpenseTitleWidget({super.key, required this.expense});
  final Expence expense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final dateformat = DateFormat('dd/MM/yy').format(expense.date);
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final price = currency.format(expense.amount);

    return Dismissible(
      key: ValueKey(expense.id),
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Icon(Icons.delete, color: colorScheme.error),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ExpenseListBloc>().add(
          ExpenseListExpenseDeleted(expense: expense),
        );
      }, // Minimal implementation to avoid errors
      child: ListTile(
        onTap: () {
          context.showAddExpensesSheet(expense);
        },
        leading: Icon(Icons.car_repair, color: colorScheme.surfaceTint),
        title: Text(expense.title, style: textTheme.titleMedium),
        subtitle: Text(
          dateformat,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
