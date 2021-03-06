import 'package:flutter/material.dart';
import 'package:masterbank/http/webclient/transaction_webclient.dart';
import 'package:masterbank/models/transaction.dart';
import 'package:masterbank/widgets/centered_message.dart';
import 'package:masterbank/widgets/loading_page.dart';

class TransactionsList extends StatelessWidget {
  final TransactionWebClient _transactionWebClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: FutureBuilder<List<Transaction>>(
        initialData: const [],
        future: _transactionWebClient.getTransactionList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return LoadingPage();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<Transaction> transactions = snapshot.data as List<Transaction>;

                if (transactions.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Transaction transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.monetization_on),
                          title: Text(
                            transaction.value.toString(),
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transaction.contact.accountNumber.toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: transactions.length,
                  );
                } else {
                  return CenteredMessage('No transactions found', icon: Icons.warning);
                }
              }

              return CenteredMessage(
                'Unknown error!',
                icon: Icons.error,
                color: Theme.of(context).errorColor,
              );
          }
          return Container();
        },
      ),
    );
  }
}
