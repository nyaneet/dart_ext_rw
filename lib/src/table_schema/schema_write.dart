import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

abstract class SchemaWrite<T extends SchemaEntry> {
  ///
  /// Inserts new entry into the source
  Future<Result<void, Failure>> update(T entry);
  ///
  /// Updates entry at the source
  Future<Result<T, Failure>> insert(T? entry);
  ///
  /// Deletes entry from the source
  Future<Result<void, Failure>> delete(T entry);
}