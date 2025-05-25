import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key, required ExpenceReporsitory expenceReporsitory})
    : expenceReporsitory = expenceReporsitory;

  final ExpenceReporsitory expenceReporsitory;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: expenceReporsitory,
      child: BlocProvider(
        create: (context) => ExpenseListBloc(repository: expenceReporsitory),
        child: MaterialApp(home: Home(), debugShowCheckedModeBanner: false),
      ),
    );
  }
}
