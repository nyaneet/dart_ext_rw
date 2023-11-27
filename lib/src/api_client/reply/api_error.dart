
// import 'package:logging/logging.dart';

class ApiError {
  // final _log = Logger('ApiError');
  final Map<String, dynamic>? _errors;
  ///
  ApiError({
    required Map<String, dynamic>? errors,
  }) : 
    _errors = errors;
  ///
  String get message => _errors?['message'] ?? '';
  ///
  String get details => _errors?['details'] ?? '';
  ///
  bool get isEmpty {
    return message.isEmpty && details.isEmpty;
  }
  ///
  bool get isNotEmpty {
    return !isEmpty;
  }
  ///
  @override
  String toString() {
    return '''$ApiError {
\t\tmessage: $message;
\t\tdetails: $details;
\t}''';
  }
}
