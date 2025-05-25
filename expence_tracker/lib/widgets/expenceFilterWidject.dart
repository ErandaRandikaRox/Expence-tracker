import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseFilterWidget extends StatelessWidget {
  const ExpenseFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = Catergory.values; // Use consistent naming
    final activeFilter = context.select((ExpenseListBloc bloc) => bloc.state.filter);

    return LimitedBox(
      maxHeight: 40,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category.toName), // Assuming toName is a method or getter
            selected: activeFilter == category,
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<ExpenseListBloc>().add(FilterExpenses(category));
              } else {
                context.read<ExpenseListBloc>().add(const FilterExpenses(null));
              }
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}