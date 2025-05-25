import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class Titlefieldwidject extends StatelessWidget {
  const Titlefieldwidject({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme = Theme.of(context).textTheme;
    final state = context.watch<ExpenseFormBloc>().state;

 final formattedDate = state.initialExpence == null
    ? DateFormat('dd/MM/yyyy').format(state.date ?? DateTime.now())
    : DateFormat('dd/MM/yyyy').format(state.initialExpence!.date);

    return GestureDetector(
      onTap: () async{
        
      },
    );
  }
}
