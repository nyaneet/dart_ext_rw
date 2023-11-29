import 'package:ext_rw/ext_rw.dart';
import 'package:ext_rw/src/table_schema/schema_write.dart';
import 'package:hmi_core/hmi_core_failure.dart';
// import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SqlWrite<T extends SchemaEntry> implements SchemaWrite<T> {
  // late final Log _log;
  final ApiAddress _address;
  final String _authToken;
  final String _database;
  final bool _keepAlive;
  final bool _debug;
  final SqlBuilder<T>? _insertSqlBuilder;
  final SqlBuilder<T>? _updateSqlBuilder;
  final SqlBuilder<T>? _deleteSqlBuilder;
  final Map<T, Function> _entryFromFactories;
  final Map<T, Function> _entryEmptyFactories;
  ///
  ///
  SqlWrite({
    required ApiAddress address,
    required String authToken,
    required String database,
    bool keepAlive = false,
    bool debug = false,
    SqlBuilder<T>? insertSqlBuilder,
    SqlBuilder<T>? updateSqlBuilder,
    SqlBuilder<T>? deleteSqlBuilder,
    required Map<T, Function> entryFromFactories,
    required Map<T, Function> entryEmptyFactories,
  }) :
    _address = address,
    _authToken = authToken,
    _database = database,
    _keepAlive = keepAlive,
    _debug = debug,
    _insertSqlBuilder = insertSqlBuilder,
    _updateSqlBuilder = updateSqlBuilder,
    _deleteSqlBuilder = deleteSqlBuilder,
    _entryFromFactories = entryFromFactories,
    _entryEmptyFactories = entryEmptyFactories; // {
  //   _log = Log("$runtimeType");
  // }
  //
  //
  @override
  Future<Result<T, Failure>> insert(T? entry) {
    T entry_;
    if (entry != null) {
      entry_ = entry;
    } else {
      entry_ = _makeEmptyEntry();
    }
    final builder = _insertSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry_);
      return _fetchWith(sql).then((result) {
        return switch(result) {
          Ok() => () {
            return Ok<T, Failure>(entry_);
          }(),
          Err(:final error) => () {
            return Err<T, Failure>(error);
          }(),
        };
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
        return switch(result) {
          Ok() => () {
            return const Ok<void, Failure>(null);
          }(),
          Err(:final error) => () {
            return Err<void, Failure>(error);
          }(),
        };
      });
    }
    throw Failure(
      message: "$runtimeType.update | updateSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
  //
  //
  @override
  Future<Result<void, Failure>> delete(T entry) {
    final builder = _deleteSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry);
      return _fetchWith(sql).then((result) {
        return switch(result) {
          Ok() => () {
            return const Ok<void, Failure>(null);
          }(),
          Err(:final error) => () {
            return Err<void, Failure>(error);
          }(),
        };
      });
    }
    throw Failure(
      message: "$runtimeType.update | updateSqlBuilder is not initialized", 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Fetchs data with new [sql]
  Future<Result<List<T>, Failure>> _fetchWith(Sql sql) {
    final request = ApiRequest(
      address: _address, 
      query: SqlQuery(
        authToken: _authToken, 
        database: _database,
        sql: sql.build(),
        keepAlive: _keepAlive,
        debug: _debug,
      ),
    );
    return request.fetch().then((result) {
      return switch (result) {
        Ok(:final value) => () {
          final reply = value;
          if (reply.hasError) {
            return Err<List<T>, Failure>(Failure(message: reply.error.message, stackTrace: StackTrace.current));
          } else {
            final List<T> entries = [];
            final rows = reply.data;
            for (final row in rows) {
              final entry = _makeEntry(row);
              entries.add(entry);
            }
            return Ok<List<T>, Failure>(entries);
          }
        }(), 
        Err(:final error) => Err<List<T>, Failure>(error),
      };
    });
  }
  ///
  ///
  T _makeEmptyEntry() {
    final constructor = _entryEmptyFactories[T];
    if (constructor != null) {
      return constructor();
    } else {
      throw Failure(
        message: "$runtimeType._makeEntry | Can't find constructor for $T", 
        stackTrace: StackTrace.current,
      );
    }
  }
  ///
  ///
  T _makeEntry(Map<String, dynamic> row) {
    final constructor = _entryFromFactories[T];
    if (constructor != null) {
      return constructor(row);
    }
    throw Failure(
      message: "$runtimeType._makeEntry | Can't find constructor for $T", 
      stackTrace: StackTrace.current,
    );
  }
}