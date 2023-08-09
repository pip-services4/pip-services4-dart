import 'dart:async';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:pip_services4_commons/pip_services4_commons.dart';
import '../controllers/HttpResponseSender.dart';

class OwnerAuthorizer {
  Future<Response?> owner(Request req, user,
      {String idParam = 'user_id'}) async {
    if (user == null) {
      return await HttpResponseSender.sendError(
          req,
          UnauthorizedException(null, 'NOT_SIGNED',
                  'User must be signed in to perform this operation')
              .withStatus(401));
    } else {
      var userId = req.params[idParam] ?? req.url.queryParameters[idParam];
      if (user.user_id != userId) {
        return await HttpResponseSender.sendError(
            req,
            UnauthorizedException(null, 'FORBIDDEN',
                    'Only data owner can perform this operation')
                .withStatus(403));
      }
    }
    return null;
  }

  Future<Response?> ownerOrAdmin(Request req, user,
      {String idParam = 'user_id'}) async {
    if (user == null) {
      return await HttpResponseSender.sendError(
          req,
          UnauthorizedException(null, 'NOT_SIGNED',
                  'User must be signed in to perform this operation')
              .withStatus(401));
    } else {
      var userId = req.params[idParam] ?? req.url.queryParameters[idParam];
      var roles = user?.roles;
      var admin = roles['admin'] != null;

      if (user.user_id != userId && !admin) {
        return await HttpResponseSender.sendError(
            req,
            UnauthorizedException(null, 'FORBIDDEN',
                    'Only data owner can perform this operation')
                .withStatus(403));
      }
    }
    return null;
  }
}
