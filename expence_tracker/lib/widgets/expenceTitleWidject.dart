import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/models/catergory.dart';
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
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ExpenseListBloc>().add(ExpenseListExpenseDeleted(expense));
      },
      child: ListTile(
        onTap: () {
          _showEditExpenseSheet(context, expense);
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

  void _showEditExpenseSheet(BuildContext context, Expence expense) {
    final titleController = TextEditingController(text: expense.title);
    final amountController = TextEditingController(
      text: expense.amount.toString(),
    );
    final dateController = TextEditingController(
      text: DateFormat('dd/MM/yy').format(expense.date),
    );
    Catergory? selectedCategory = expense.catergory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: StatefulBuilder(
              builder:
                  (context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Expense Title',
                        ),
                      ),
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date (dd/MM/yy)',
                        ),
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: expense.date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            dateController.text = DateFormat(
                              'dd/MM/yy',
                            ).format(pickedDate);
                          }
                        },
                      ),
                      DropdownButton<Catergory>(
                        value: selectedCategory,
                        hint: const Text('Select Category'),
                        items:
                            Catergory.values.map((Catergory category) {
                              return DropdownMenuItem<Catergory>(
                                value: category,
                                child: Text(
                                  category.toString().split('.').last,
                                ),
                              );
                            }).toList(),
                        onChanged: (Catergory? newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final updatedExpense = Expence(
                            id: expense.id,
                            title:
                                titleController.text.isNotEmpty
                                    ? titleController.text
                                    : expense.title,
                            amount:
                                double.tryParse(amountController.text) ??
                                expense.amount,
                            date:
                                DateFormat(
                                  'dd/MM/yy',
                                ).tryParse(dateController.text) ??
                                expense.date,
                            catergory: selectedCategory ?? expense.catergory,
                          );
                          context.read<ExpenseListBloc>().add(
                            ExpenseListExpenseUpdated(updatedExpense),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
            ),
          ),
    );
  }
}
