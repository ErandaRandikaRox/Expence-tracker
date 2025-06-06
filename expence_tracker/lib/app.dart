import 'package:expense_tracker/expence_list/expence_list_bloc.dart';
import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/repositories/expence_reporsitory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.expenceReporsitory,
    required this.theme,
    required this.darkTheme,
  });

  final ExpenceRepository expenceReporsitory;
  final ThemeData theme;
  final ThemeData darkTheme;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: expenceReporsitory,
      child: BlocProvider(
        create: (context) => ExpenseListBloc(repository: expenceReporsitory),
        child: MaterialApp(
          theme: theme, // Apply the light theme
          darkTheme: darkTheme, // Apply the dark theme
          themeMode: ThemeMode.system, // Use system theme mode (light/dark)
          home: const Home(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}