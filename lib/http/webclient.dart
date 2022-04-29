import 'package:http/http.dart';

void getTransactionsList() async {
  // Caso esteja usando um servidor local é nescessário usar o IP da mesma rede
  final Response response = await get(Uri.parse('http://192.168.0.6:8080/transactions'));

  print(response.body);
}
