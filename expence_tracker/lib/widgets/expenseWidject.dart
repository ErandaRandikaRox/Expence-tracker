import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/widgets/expenceTitleWidject.dart';
import 'package:expense_tracker/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseWidget extends StatelessWidget {
  const ExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseListBloc, ExpenseListState>(
      builder: (context, state) {
        if (state.status == ExpenseListStatus.loading) {
          return const LoadingWidget(radius: 12, addPadding: true);
        }
        final expenses = state.filteredExpences.toList();

        if (state.status == ExpenseListStatus.success && expenses.isEmpty) {
          return const Center(child: Text('No expenses found'));
        }
        return ListView.separated(
          itemBuilder: (context, index) => ExpenseTitleWidget(
            expense: expenses[index], // Pass the specific expense
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: expenses.length,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
        );
      },
    );
  }
}