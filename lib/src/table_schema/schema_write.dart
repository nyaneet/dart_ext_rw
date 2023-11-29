import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

abstract class SchemaWrite<T> {
  Future<Result<void, Failure>> update(T entry);
  Future<Result<void, Failure>> insert({T? entry});
  Future<Result<void, Failure>> delete({T entry});
}