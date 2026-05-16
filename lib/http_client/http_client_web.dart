import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

Future<http.Client> httpClient() async {
  return http.Client();
}

Future<dio.Dio> dioClient() async {
  return dio.Dio();
}
