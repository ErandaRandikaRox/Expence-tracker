import 'package:expense_tracker/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker/models/expence.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

extension Appx on BuildContext {
  Future<void> showAddExpencesSheet(Expence? expence, {required Expence expense}) {
    return showModalBottomSheet(
      context: this,
      builder:
          (context) => BlocProvider(
            create: (context) => ExpenseFormBloc(
              initialExpence: expence,
              repository:  read<ExpenceRepository>(),
              context: this
               ),
            child: Container(),
          ),

      isScrollControlled: true,
      showDragHandle: true,
    );
  }
}
