import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CatergoryfieldWidject extends StatelessWidget {
  const CatergoryfieldWidject({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final bloc = context.read<ExpenseFormBloc>();
    final state = context.watch<ExpenseFormBloc>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Select Category',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
            height: 1,
            fontWeight: FontWeight.w400,
          ),
        ),

        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 0,
          children: Catergory.values
              .where((category) => category != Catergory.all)
              .map(
                (currentCategory) =>
                    ChoiceChip(
                      label: Text(currentCategory.toName),
                      selected: currentCategory == state.catergory,
                      onSelected: (_) {
                        bloc.add(ExpenseCategoryChanged(currentCategory));
                      },
                    ),
              ).toList(),
        ),
      ],
    );
  }
}