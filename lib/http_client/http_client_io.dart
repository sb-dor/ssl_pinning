import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

///  To generate a binary certificate file
///
///  https://habr.com/ru/articles/504914/
///  https://github.com/sb-dor/ssl_certificate_binary_generator

Future<http.Client> httpClient() async {
  final sslCert = await rootBundle.load('assets/go_avera_cert.pem');
  final securityContext = SecurityContext(withTrustedRoots: false)
    ..setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  final httpClient = HttpClient(context: securityContext);
  return IOClient(httpClient);
}

Future<dio.Dio> dioClient() async {
  final sslCert = await rootBundle.load('assets/go_avera_cert.pem');
  final securityContext = SecurityContext(withTrustedRoots: false)
    ..setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  final dioInstance = dio.Dio()
    ..httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient(context: securityContext);
      },
    );
  return dioInstance;
}
