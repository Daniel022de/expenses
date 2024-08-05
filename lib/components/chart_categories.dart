import 'package:finApp/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionCategoriesChart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const TransactionCategoriesChart(this.recentTransactions, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Transaction> todayTransactions = recentTransactions
        .where((tx) =>
            tx.date.year == DateTime.now().year &&
            tx.date.month == DateTime.now().month &&
            tx.date.day == DateTime.now().day)
        .toList();

    double getTotalForCategory(
        List<Transaction> transactions, String category) {
      return transactions
          .where((tx) => tx.category == category)
          .fold(0, (sum, tx) => sum + tx.value);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: <Widget>[
              const Text(
                'DINHEIRO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${getTotalForCategory(todayTransactions, 'Dinheiro').toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              const Text(
                'Cartão A',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${getTotalForCategory(todayTransactions, 'Cartão A').toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              const Text(
                'Cartão B',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${getTotalForCategory(todayTransactions, 'Cartão B').toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              const Text(
                'Cartão C',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${getTotalForCategory(todayTransactions, 'Cartão C').toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
