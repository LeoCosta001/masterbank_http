import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:masterbank/models/contact.dart';
import 'package:masterbank/models/transaction.dart';

Future<List<Transaction>> getTransactionsList() async {
  final Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  // Caso esteja usando um servidor local é nescessário usar o IP da mesma rede
  final Response response = await client
      .get(Uri.parse('http://192.168.0.6:8080/transactions'))
      .timeout(const Duration(seconds: 15));

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

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('####### Request ######');
    print('url: ${data.url}');
    print('method: ${data.method}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('####### Response ######');
    print('url: ${data.url}');
    print('method: ${data.method}');
    print('headers: ${data.headers}');
    print('status_code: ${data.statusCode}');
    print('body: ${data.body}');
    return data;
  }
}
