import 'dart:convert';

import 'package:logging/logging.dart';

class ApiReply {
  final _log = Logger('ApiReply');
  late String _authToken;
  late String _id;
  late Map<String, String> _sql;
  late List<Map<String, dynamic>> _data;
  late List<String> _errors;
  ///
  ApiReply({
    required String authToken,
    required String id,
    required Map<String, String> sql,
    required List<Map<String, dynamic>> data,
    required List<String> errors,
  }) : 
    _authToken = authToken,
    _id = id,
    _sql = sql, 
    _data = data, 
    _errors = errors;
  ///
  ApiReply.fromJson(String jsonString) {
    // _log.fine('.fromJson | jsonString: $jsonString');
    final jsonMap = json.decode(jsonString);
    _log.fine('.fromJson | jsonMap: $jsonMap');
    _authToken = jsonMap['auth_token'];
    _id = jsonMap['id'];
    _sql = jsonMap['sql'] ?? {};
    _data = (jsonMap['data'] as List<dynamic>).map((e) {
      return (e as Map<dynamic, dynamic>).map((key, value) => MapEntry(key.toString(), value));
      // final key = (e as MapEntry).key;
      // final value = (e as MapEntry).value;
      // return MapEntry<String, dynamic>(key.toString(), value);
    }).toList();
    _errors = (jsonMap['errors'] as List<dynamic>).map((e) => '$e').toList();
  }
  ///
  String get authToken => _authToken;
  ///
  String get id => _id;
  ///
  Map<String, String> get sql => _sql;
  ///
  List<Map<String, dynamic>> get data => _data;
  ///
  List<String> get errors => _errors;
  ///
  @override
  String toString() {
    return '''$ApiReply {
\t\tauthToken: $_authToken;
\t\tid: $_id;
\t\tsql: $_sql;
\t\tdata: $_data;
\t\terrors: $_errors;
\t}''';
  }
}
