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
  final Map<T, Function> _entryFromFactories;
  final Map<T, Function> _entryEmptyFactories;
  final Map<String, T> _entries = {};
  ///
  ///
  SqlWrite({
    SqlBuilder<T>? insertSqlBuilder,
    SqlBuilder<T>? updateSqlBuilder,
    SqlBuilder<T>? deleteSqlBuilder,
    required Map<T, Function> entryFromFactories,
    required Map<T, Function> entryEmptyFactories,
  }) :
    _insertSqlBuilder = insertSqlBuilder,
    _updateSqlBuilder = updateSqlBuilder,
    _deleteSqlBuilder = deleteSqlBuilder,
    _entryFromFactories = entryFromFactories,
    _entryEmptyFactories = entryEmptyFactories {
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
    T entry_;
    if (entry != null) {
      entry_ = entry;
    } else {
      final constructor = _entryEmptyFactories[T];
      if (constructor != null) {
        entry_ = constructor();
      } else {
        throw Failure(
          message: "$runtimeType._makeEntry | Can't find constructor for $T", 
          stackTrace: StackTrace.current,
        );
      }
    }
    final builder = _insertSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry_);
      return _fetchWith(sql).then((result) {
        if (result is Ok) {
          _entries[entry_.key] = entry_;
        }
        return result;
      });
    }
    throw Failure(
      message: "$runtimeType.insert | insertSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
  //
  //
  @override
  Future<Result<void, Failure>> update(T entry) {
    final builder = _updateSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry);
      return _fetchWith(sql).then((result) {
        if (result is Ok) {
          _entries[entry.key] = entry;
        }
        return result;
      });
    }
    throw Failure(
      message: "$runtimeType.update | updateSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
}