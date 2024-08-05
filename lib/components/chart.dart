import 'package:finApp/components/chart_categories.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction, {Key? key}) : super(key: key);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      String dayOfWeek = _mapDayOfWeek(weekDay.weekday);

      return {
        'day': dayOfWeek,
        'value': totalSum,
      };
    }).reversed.toList();
  }

  String _mapDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'SEG';
      case DateTime.tuesday:
        return 'TER';
      case DateTime.wednesday:
        return 'QUA';
      case DateTime.thursday:
        return 'QUI';
      case DateTime.friday:
        return 'SEX';
      case DateTime.saturday:
        return 'SÁB';
      case DateTime.sunday:
        return 'DOM';
      default:
        return '';
    }
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 6,
          margin: const EdgeInsets.all(20),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: groupedTransactions.map((tr) {
                  return Expanded(
                    child: ChartBar(
                      label: tr['day'] as String,
                      value: tr['value'] as double,
                      percentage: _weekTotalValue == 0
                          ? 0
                          : (tr['value'] as double) / _weekTotalValue,
                    ),
                  );
                }).toList(),
              )),
        ),
        const SizedBox(height: 30),
        TransactionCategoriesChart(recentTransaction),
        const SizedBox(height: 30)
      ],
    );
  }
}
