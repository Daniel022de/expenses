import 'package:finApp/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final void Function(String) onRemove;

  const TransactionList(this._transactions, this.onRemove, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: _transactions.isEmpty
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Nenhuma Transação Cadastrada!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tr = _transactions[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: FittedBox(
                              child: Text(
                            'R\$${tr.value}',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      title: Text(
                        tr.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(DateFormat('d/MM/y').format(tr.date)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => onRemove(tr.id),
                      ),
                    ),
                  );
                },
              ));
  }
}
