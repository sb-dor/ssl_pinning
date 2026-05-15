// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ssl_pinning/config.dart';
import 'package:ssl_pinning/http_client/http_client.dart';

void main() => runZonedGuarded(
  () async {
    WidgetsFlutterBinding.ensureInitialized();
    final dependencies = Dependencies();
    dependencies.client = await httpClient();
    runApp(Application(dependencies: dependencies));
  },
  (error, stackTrace) {
    print(error);
    print(stackTrace);
  },
);

class Dependencies {
  late final http.Client client;
}

/// {@template main}
/// DependenciesScope widget.
/// {@endtemplate}
class DependenciesScope extends InheritedWidget {
  /// {@macro main}
  const DependenciesScope({
    required this.dependencies,
    required super.child,
    super.key, // ignore: unused_element_parameter
  });

  static Dependencies of(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType<DependenciesScope>()?.widget;
    assert(widget != null, 'No DependenciesScope was found in element tree');
    return (widget as DependenciesScope).dependencies;
  }

  final Dependencies dependencies;

  @override
  bool updateShouldNotify(covariant DependenciesScope oldWidget) => false;
}

/// {@template main}
/// Application widget.
/// {@endtemplate}
class Application extends StatefulWidget {
  /// {@macro main}
  const Application({
    super.key, // ignore: unused_element_parameter
    required this.dependencies,
  });

  final Dependencies dependencies;

  @override
  State<Application> createState() => _ApplicationState();
}

/// State for widget Application.
class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) => DependenciesScope(
    dependencies: widget.dependencies,
    child: const MaterialApp(home: HomeScreen()),
  );
}

/// {@template main}
/// HomeScreen widget.
/// {@endtemplate}
class HomeScreen extends StatefulWidget {
  /// {@macro main}
  const HomeScreen({
    super.key, // ignore: unused_element_parameter
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State for widget HomeScreen.
class _HomeScreenState extends State<HomeScreen> {
  late final Dependencies dependencies;
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    dependencies = DependenciesScope.of(context);
    sslPinningTest();
  }

  Future<void> sslPinningTest() async {
    ///
    /// https://jsonplaceholder.typicode.com/todos/1
    ///
    ///   This url throws:
    ///
    ///   Handshake error in client
    ///   (OS Error:CERTIFICATE_VERIFY_FAILED: application verification failure(handshake.cc:298))
    ///
    ///

    const baseUrl = Config.baseUrl;
    const storeName = Config.storeName;
    final response = await dependencies.client.get(
      Uri.parse('$baseUrl/user/session'),
      headers: {
        'Authorization': 'Bearer dfsmlfdsfsdfsdf',
        'X-Store-Db': storeName,
        'X-Warehouse-Id': 1.toString(),
      },
    );
    print(response.body);
    print(response.statusCode);
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SSL Pinning')));
}
