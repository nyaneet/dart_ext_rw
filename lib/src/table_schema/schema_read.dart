import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

abstract class SchemaRead<T extends SchemaEntry, P> {
  Future<Result<List<T>, Failure>> fetch(P params);
}