import 'dart:convert';

import 'package:finApp/components/chart.dart';
import 'package:finApp/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);

  final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[900],
    hintColor: Colors.blueAccent,
    backgroundColor: Colors.grey[850],
    scaffoldBackgroundColor: Colors.grey[900],
    fontFamily: 'Quicksand',
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontFamily: 'Quicksand',
        color: Colors.white70,
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      backgroundColor: Colors.blueGrey,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blueAccent,
      textTheme: ButtonTextTheme.primary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blueAccent,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: theme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  List<Transaction> _transactions = [];

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsData = prefs.getString('transactions');

    if (transactionsData != null) {
      final List<dynamic> decodedData = jsonDecode(transactionsData);
      final List<Transaction> loadedTransactions = decodedData
          .map((item) {
            return Transaction.fromJson(item as Map<String, dynamic>);
          })
          .toList()
          .cast<Transaction>();

      setState(() {
        _transactions = loadedTransactions;
      });
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_transactions.map((tr) => tr.toJson()).toList());
    prefs.setString('transactions', encodedData);
  }

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
            (tr) => tr.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  _addTransaction(String title, double value, DateTime date, String category) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: date,
        category: category);

    setState(() {
      _transactions.add(newTransaction);
    });

    _saveTransactions();
    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
    _saveTransactions();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Despesas Pessoais',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        ),
      ],
    );
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: availableHeight * 0.40,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: availableHeight * 0.60,
              child: TransactionList(_transactions, _removeTransaction),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
