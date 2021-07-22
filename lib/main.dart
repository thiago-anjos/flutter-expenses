import 'package:expenses/components/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import '/models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Cairo',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
            ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Cairo', fontSize: 16, color: Colors.blue)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.dark().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.w700)))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<StatefulWidget> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  // criar botão para IOS e Android
  Widget _getIconButton(IconData icon, VoidCallback fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartIcon =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(_showChart ? iconList : chartIcon, () {
          setState(() {
            _showChart = !_showChart;
          });
        }),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      )
    ];

    final titleAppBar = 'Gerenciamento Financeiro';

    final PreferredSizeWidget appBar = AppBar(
      title: Text(
        titleAppBar,
        style: TextStyle(fontSize: 20 * mediaQuery.textScaleFactor),
      ),
      actions: actions,
    );

    final appBarCupertino = CupertinoNavigationBar(
      middle: Text(titleAppBar),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );

    final availabelHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showChart || !isLandscape)
            Container(
                height: availabelHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(_recentTransactions)),
          if (!_showChart || !isLandscape)
            Container(
                height: availabelHeight * (isLandscape ? 1 : 0.65),
                child: TransactionList(_transactions, _deleteTransaction)),
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
            navigationBar: appBarCupertino,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _openTransactionFormModal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
