import 'dart:convert';

import 'package:dart_api_client/src/core/api_query_type/api_query_type.dart';
import 'package:uuid/uuid.dart';

class PythonQuery implements ApiQueryType {
  final String _authToken;
  late String _id;
  final String _script;
  final String _params;
  ///
  /// Prapares sql for some database
  PythonQuery({
    required String authToken,
    required String script,
    required String params,
  }) :
    _authToken = authToken,
    _script = script,
    _params = params;
  ///
  @override
  bool valid() {
    return true;
    /// some simplest sql syntax validation to be implemented
  }
  ///
  @override
  String buildJson() {
    _id = const Uuid().v1();
    final jsonString = json.encode({
      'auth_token': _authToken,
      'id': _id,
      'python': {
        'script': _script,
        'params': _params,
      },
    });
    return jsonString;
  }
  ///
  @override
  String get authToken => _authToken;
  ///
  @override
  String get id => _id;
  ///
  String get script => _script;
}