import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

abstract class SchemaRead<T, P> {
  Future<Result<List<T>, Failure>> fetch(P params);
}