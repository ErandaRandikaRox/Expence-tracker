import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:expense_tracker/widgets/addButtonWidject.dart';
import 'package:expense_tracker/widgets/expenceFilterWidject.dart';
import 'package:expense_tracker/widgets/expenseWidject.dart';
import 'package:expense_tracker/widgets/textFieldWidgect.dart';
import 'package:expense_tracker/widgets/totalExpenceWidject.dart';
import 'package:expense_tracker/widgets/amountfieldwidject.dart';
import 'package:expense_tracker/widgets/catergoryfieldWidject.dart';
import 'package:expense_tracker/widgets/datefieldwidject.dart';
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => BlocProvider(
              create: (context) => ExpenseFormBloc(
                repository: RepositoryProvider.of<ExpenceReporsitory>(context),
                context: context,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Add New Expense',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidgect(),
                      const SizedBox(height: 16),
                      Amountfieldwidject(),
                      const SizedBox(height: 16),
                      const CatergoryfieldWidject(),
                      const SizedBox(height: 16),
                      const Datefieldwidject(),
                      const SizedBox(height: 16),
                      BlocListener<ExpenseFormBloc, ExpenseFormState>(
                        listener: (context, state) {
                          if (state.status == ExpenseFormStatus.success) {
                            Navigator.pop(context);
                          } else if (state.status == ExpenseFormStatus.failure && state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage!)),
                            );
                          }
                        },
                        child: const AddButtonWidget(),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}