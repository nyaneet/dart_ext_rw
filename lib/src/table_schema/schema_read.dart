import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

abstract class SchemaRead<T extends SchemaEntry, P> {
  ///
  /// Fetchs entries with new sql built from [params] calling sqlBuilder(params)
  Future<Result<List<T>, Failure>> fetch(P params);
}