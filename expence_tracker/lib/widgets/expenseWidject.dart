import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Expensewidject extends StatelessWidget {
  const Expensewidject({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseListBloc, ExpenseListState>(
      builder: (context, state) {
        if (state.status == ExpenseListStatus.loading) {
          return LoadingWidject(radius: 12, addPadding: true);
        }
        final expenses = state.filteredExpences.toList();

        if (state.status == ExpenseListStatus.success && expenses.isEmpty) {
          return EmptyListWidject();
        }
        return ListView.separated(
          itemBuilder: (context, index) => ExpensetitleWidject(),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: 1,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}
