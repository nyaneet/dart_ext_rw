import 'package:ext_rw/ext_rw.dart';
import 'package:ext_rw/src/table_schema/schema_write.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SqlWrite<T extends SchemaEntry> implements SchemaWrite<T> {
  late final Log _log;
  final SqlBuilder<T>? _insertSqlBuilder;
  final SqlBuilder<T>? _updateSqlBuilder;
  final SqlBuilder<T>? _deleteSqlBuilder;
  ///
  ///
  SqlWrite({
    SqlBuilder<T>? insertSqlBuilder,
    SqlBuilder<T>? updateSqlBuilder,
    SqlBuilder<T>? deleteSqlBuilder,
  }) :
    _insertSqlBuilder = insertSqlBuilder,
    _updateSqlBuilder = updateSqlBuilder,
    _deleteSqlBuilder = deleteSqlBuilder {
    _log = Log("$runtimeType");
  }
  //
  //
  @override
  Future<Result<void, Failure>> delete(T entry) {
    // TODO: implement delete
    throw UnimplementedError();
  }
  //
  //
  @override
  Future<Result<void, Failure>> insert(T? entry) {
    // TODO: implement insert
    throw UnimplementedError();
  }
  //
  //
  @override
  Future<Result<void, Failure>> update(T entry) {
    // TODO: implement update
    throw UnimplementedError();
  }
}