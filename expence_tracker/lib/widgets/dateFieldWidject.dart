import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DateFieldWidget extends StatelessWidget {
  const DateFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final state = context.watch<ExpenseFormBloc>().state;
    final bloc = context.read<ExpenseFormBloc>();

    // Use state.date if available, otherwise fallback to current date
    final displayDate = state.date ?? DateTime.now();
    final formattedDate = DateFormat('dd/MM/yy').format(displayDate);

    return GestureDetector(
      onTap: () async {
        final today = DateTime.now();
        final selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1999),
          lastDate: DateTime(today.year + 50),
        );
        if (selectedDate != null) {
          bloc.add(ExpenseDateChanged(selectedDate));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Date',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.5),
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            formattedDate,
            style: textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}