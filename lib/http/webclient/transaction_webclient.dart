import 'dart:convert';

import 'package:http/http.dart';
import 'package:masterbank/http/webclient.dart';
import 'package:masterbank/models/contact.dart';
import 'package:masterbank/models/transaction.dart';

class TransactionWebClient {
  Future<List<Transaction>> getTransactionList() async {
    final Response response =
        await client.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 15));

    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];

    for (Map<String, dynamic> element in decodedJson) {
      final Transaction newTransaction = Transaction(
        element['value'],
        Contact(
          0,
          element['contact']['name'],
          element['contact']['accountNumber'],
        ),
      );

      transactions.add(newTransaction);
    }

    return transactions;
  }

  Future<Transaction> postTransaction(Transaction transaction) async {
    // Convertando o objeto Dart para um tipo JSON
    final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.accountName,
        'accountNumber': transaction.contact.accountNumber
      }
    };

    final String transactionJson = jsonEncode(transactionMap);

    final Response response = await client
        .post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json', 'password': '1000'},
          body: transactionJson,
        )
        .timeout(const Duration(seconds: 15));

    Map<String, dynamic> responseBodyToJson = jsonDecode(response.body);

    return Transaction(
      responseBodyToJson['value'],
      Contact(
        0,
        responseBodyToJson['contact']['name'],
        responseBodyToJson['contact']['accountNumber'],
      ),
    );
  }
}
