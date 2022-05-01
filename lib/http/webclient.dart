import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:masterbank/http/interceptors/logging_interceptors.dart';

final Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);
// Caso esteja usando um servidor local é nescessário usar o IP da mesma rede
const String baseUrl = 'http://192.168.0.6:8080/transactions';
