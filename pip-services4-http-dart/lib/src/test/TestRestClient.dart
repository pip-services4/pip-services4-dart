import 'package:pip_services4_components/pip_services4_components.dart';

import '../clients/RestClient.dart';

/// REST client used for automated testing.
class TestRestClient extends RestClient {
  TestRestClient(String baseRoute) : super() {
    this.baseRoute = baseRoute;
  }

  /// Calls a remote method via HTTP/REST protocol.
  ///
  /// [method]            HTTP method: "get", "head", "post", "put", "delete"
  /// [route]             a command route. Base route will be added to this route
  /// [context]           (optional) a context to trace execution through call chain.
  /// [params]            (optional) query parameters.
  /// [data]              (optional) body object.
  /// Return                 a result object.
  @override
  Future call(String method, String route, IContext? context,
      Map<String, String> params,
      [data]) async {
    return super.call(method, route, context, params, data);
  }
}
