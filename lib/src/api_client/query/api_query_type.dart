abstract class ApiQueryType {
  bool valid();
  ///
  String buildJson({String authToken = '', bool debug = false});
  ///
  String get id;
}