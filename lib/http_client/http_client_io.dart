import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

Future<Client> httpClient() async {
  final sslCert = await rootBundle.load('assets/go_avera_cert.pem');
  final securityContext = SecurityContext(withTrustedRoots: false)
    ..setTrustedCertificatesBytes(sslCert.buffer.asUint8List());
  final httpClient = HttpClient(context: securityContext);
  return IOClient(httpClient);
}
