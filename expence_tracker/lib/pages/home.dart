import 'package:expense_tracker/extentions/extenstion.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Good moring")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TotalExpenceWidject(),
            SizedBox(height: 16),
            ExpenceFilterWidject(),
            SizedBox(height: 16),
            ExpenceWidject(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.showAddExpences,
        child: const Icon(Icons.add),
      ),
    );
  }
}
