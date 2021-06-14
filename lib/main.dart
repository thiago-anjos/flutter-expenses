import 'package:flutter/material.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciamento Financeiro')),
      body: Center(
        child: Text('Bem vindo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: "Teste",
        child: const Icon(Icons.add),
      ),
    );
  }
}
