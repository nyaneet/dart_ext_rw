import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
/// Abstraction on read data access 
abstract interface class SchemaRead<T extends SchemaEntry, P> {
  ///
  /// Empty instance implements SchemaRead
  const factory SchemaRead.empty() = _SchemaReadEmpty;
  ///
  /// Fetchs entries with new sql built from [params]
  Future<Result<List<T>, Failure>> fetch(P params);
}

///
/// Empty instance implements SchemaRead
class _SchemaReadEmpty<T extends SchemaEntry, P> implements SchemaRead<T, P> {
  ///
  ///
  const _SchemaReadEmpty();
  //
  //
  @override
  Future<Result<List<T>, Failure>> fetch(params) {
    return Future.value(Err(Failure(
      message: "$runtimeType.fetch | read - not initialized", 
      stackTrace: StackTrace.current,
    )));
  }
}