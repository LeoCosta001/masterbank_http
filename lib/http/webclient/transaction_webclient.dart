import 'dart:convert';

import 'package:http/http.dart';
import 'package:masterbank/http/webclient.dart';
import 'package:masterbank/models/transaction.dart';

class TransactionWebClient {
  Future<List<Transaction>> getTransactionList() async {
    final Response response =
    await client.get(Uri.parse(baseUrl));
    final List<dynamic> responseBodyToJson = jsonDecode(response.body);
    return responseBodyToJson
        .map((dynamic jsonElement) => Transaction.fromJson(jsonElement))
        .toList();
  }

  Future<Transaction> postTransaction(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client
        .post(
      Uri.parse(baseUrl),
      // O password ainda precisa ser 1000 mas agora o usuário precisa digitar
      headers: {'Content-Type': 'application/json', 'password': password},
      body: transactionJson,
    )
        .timeout(const Duration(seconds: 15));

    // Verifica o Status code da resposta e emite um Exception error com uma mensagem especifica para ser tratado pelo "catchError(...)"
    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    // Retorna um erro com uma mensagem especifica
    throw HttpException(_statusCodeResponse[response.statusCode]);
  }

  static final Map<int, String?> _statusCodeResponse = {
    400: 'Error on submit transaction',
    401: 'Authentication failed',
    404: 'Page not found',
    409: 'Transaction always exists',
    500: 'Unexpected Error'
  };
}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
}
