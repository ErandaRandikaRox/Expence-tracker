import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/widgets/expenceFilterWidject.dart';
import 'package:expense_tracker/widgets/expenseWidject.dart';
import 'package:expense_tracker/widgets/totalExpenceWidject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Good morning")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<ExpenseListBloc, ExpenseListState>(
              builder: (context, state) {
                // Calculate total amount from expenses
                final totalAmount = state.filteredExpences.fold<double>(
                  0.0,
                  (sum, expense) => sum + (expense.amount ?? 0.0),
                );
                return TotalExpenseWidget(totalAmount: totalAmount);
              },
            ),
            const SizedBox(height: 16),
            const ExpenseFilterWidget(),
            const SizedBox(height: 16),
            const ExpenseWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ensure context.showAddExpences is defined; this might be a custom extension
          // If not, replace with actual logic to show add expense screen
          // context.showAddExpences();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}