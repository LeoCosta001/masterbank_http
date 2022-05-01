import 'package:http_interceptor/http_interceptor.dart';

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
