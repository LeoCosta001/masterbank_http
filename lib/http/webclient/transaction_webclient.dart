import 'dart:convert';

import 'package:http/http.dart';
import 'package:masterbank/http/webclient.dart';
import 'package:masterbank/models/transaction.dart';

class TransactionWebClient {
  Future<List<Transaction>> getTransactionList() async {
    final Response response =
        await client.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 15));

    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  Future<Transaction> postTransaction(Transaction transaction) async {

    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client
        .post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json', 'password': '1000'},
          body: transactionJson,
        )
        .timeout(const Duration(seconds: 15));

    return _toTransaction(response);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> responseBodyToJson = jsonDecode(response.body);
    final List<Transaction> transactions = [];

    for (Map<String, dynamic> transaction in responseBodyToJson) {
      transactions.add(Transaction.fromJson(transaction));
    }

    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> responseBodyToJson = jsonDecode(response.body);
    return Transaction.fromJson(responseBodyToJson);
  }
}
