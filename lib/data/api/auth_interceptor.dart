import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:protein_tracker/secrets.dart';

class AuthInterceptor implements RequestInterceptor {

  @override
  FutureOr<Request> onRequest(Request request) {
    final params = {
      'app_id': Secrets.edamamAppId,
      'app_key': Secrets.edamamAppKey,
      'nutrition-type': "logging",
      'category': ["generic-foods", "packaged-foods"],
    };

    return request.copyWith(parameters: {...request.parameters, ...params});
  }
}
