abstract class ApiQueryType {
  bool valid();
  ///
  String buildJson();
  ///
  String get authToken;
  ///
  String get id;
}