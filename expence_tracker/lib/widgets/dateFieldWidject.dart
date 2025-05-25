import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Datefieldwidject extends StatelessWidget {
  const Datefieldwidject({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorsheme = theme.colorScheme;
    final TextTheme = theme.textTheme;

    final bloc = context.read<ExpenseFormBloc>();
    final state = context.watch<ExpenseFormBloc>().state;
    final formatedate = DateFormat('DD//MM/YY').format(DateTime.now());
    return GestureDetector(
      onTap: () async {
        final today = DateTime.now();
        final selectdate = await showDatePicker(
          context: context,
          firstDate: DateTime(1999),
          lastDate: DateTime(today.year + 50),
        );
        if (selectdate != null) {
          bloc.add(ExpenseDateChanged(selectdate));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Date',
            style: TextTheme.labelLarge?.copyWith(
              color: colorsheme.onBackground.withOpacity(0.5),
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10,),
          Text(formatedate,style: TextTheme.titleLarge,)
        ],
      ),
    );
  }
}
