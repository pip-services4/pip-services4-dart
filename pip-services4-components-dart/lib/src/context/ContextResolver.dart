import 'IContext.dart';

/// Context resolver that processes context and extracts values from there.
/// See [IContext]
///
class ContextResolver {
  /// Extracts trace id from execution context.
  ///
  /// - [context] execution context to trace execution through call chain.
  /// Returns a trace id or <code>null</code> if it is not defined.
  /// See [IContext]
  static String getTraceId(IContext? context) {
    if (context == null) {
      return "";
    }
    var traceId = context.get("trace_id") ?? context.get("traceId");
    return traceId != null ? "" + traceId : "";
  }

  /// Extracts client name from execution context.
  ///
  /// - [context] execution context to trace execution through call chain.
  /// Returns a client name or <code>null</code> if it is not defined.
  /// See [IContext]
  static String getClient(IContext? context) {
    if (context == null) {
      return "";
    }
    var client = context.get("client");
    return client != null ? "" + client : "";
  }

  /// Extracts user name (identifier) from execution context.
  ///
  /// - [context] execution context to trace execution through call chain.
  /// Returns a user reference or <code>null</code> if it is not defined.
  /// See [IContext]
  static String getUser(IContext? context) {
    if (context == null) {
      return "";
    }
    var user = context.get("user");
    return user != null ? "" + user : "";
  }
}
