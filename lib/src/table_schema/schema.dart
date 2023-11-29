import 'package:ext_rw/ext_rw.dart';
import 'package:ext_rw/src/table_schema/schema_read.dart';
import 'package:ext_rw/src/table_schema/schema_write.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

typedef SqlBuilder<T extends SchemaEntry> = Sql Function(Sql sql, T entry);


///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class Schema<T extends SchemaEntry> {
  late final Log _log;
  final List<Field> _fields;
  final Map<String, T> _entries = {};
  final SchemaRead<T, dynamic>? _read;
  final SchemaWrite<T>? _write;
  final Map<String, Schema> _relations;
  final Map<T, Function> _entryFromFactories;
  final Map<T, Function> _entryEmptyFactories;
  Sql _sql = Sql(sql: '');
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  Schema({
    required List<Field> fields,
    SchemaRead<T, dynamic>? read,
    SchemaWrite<T>? write,
    Map<String, Schema> relations = const {},
    required Map<T, Function> entryFromFactories,
    required Map<T, Function> entryEmptyFactories,
  }) :
    _fields = fields,
    _read = read,
    _write = write,
    _relations = relations,
    _entryFromFactories = entryFromFactories,
    _entryEmptyFactories = entryEmptyFactories {
      _log = Log("$runtimeType");
    }
  ///
  /// Returns a list of table field names
  List<Field> get fields {
    return _fields;
  }
  ///
  /// Returns a list of table field keys
  List<String> get keys {
    return _fields.map((field) => field.key).toList();
  }
  ///
  ///
  List<T> get entries => _entries.values.toList();
  ///
  /// Fetchs data with existing sql
  // Future<Result<List<SchemaEntry>, Failure>> refresh() {
  //   if (_sql.build().isEmpty) {
  //     _sql = _fetchSqlBuilder([]);
  // }
  //   return fetchWith(_sql);
  // }
  ///
  /// Fetchs data with new sql built from [values] calling fetchSqlBuilder(values)
  Future<Result<List<T>, Failure>> fetch(params) async {
    await fetchRelations();
    final read = _read;
    if (read != null) {
      return read.fetch(params);
    }
    return Future.value(
      Err<List<T>, Failure>(Failure(
        message: "$runtimeType.relation | read - not initialized", 
        stackTrace: StackTrace.current,
      )),
    );
  }
  ///
  /// Returns relation Result<Scheme> if exists else Result<Failure>
  Result<Schema, Failure> relation(String id) {
    final rel = _relations[id];
    if (rel != null) {
      return Ok(rel);
    } else {
      return Err(Failure(
        message: "$runtimeType.relation | id: $id - not found", 
        stackTrace: StackTrace.current,
      ));
    }
  }
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
  ///
  /// Fetchs data with new [sql]
  Future<Result<List<T>, Failure>> fetchWith(Sql sql) {
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
            _entries.clear();
            final rows = reply.data;
            for (final row in rows) {
              final entry = _makeEntry(row);
              if (_entries.containsKey(entry.key)) {
                throw Failure(
                  message: "$runtimeType.fetchWith | dublicated entry key: ${entry.key}", 
                  stackTrace: StackTrace.current,
                );
              }
              _entries[entry.key] = entry;
            }
          }
          return Ok<List<T>, Failure>(_entries.values.toList());
        }(), 
        Err(:final error) => Err<List<T>, Failure>(error),
      };
    });
  }
  ///
  /// Inserts new entry into the table scheme
  Future<Result<void, Failure>> insert({T? entry}) {
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
      return fetchWith(sql).then((result) {
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
  ///
  /// Updates entry of the table scheme
  Future<Result<void, Failure>> update(T entry) {
    final builder = _updateSqlBuilder;
    if (builder != null) {
      final initialSql = Sql(sql: '');
      final sql = builder(initialSql, entry);
      return fetchWith(sql).then((result) {
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
  ///
  /// Fetchs data of the relation schemes only (with existing sql)
  Future<void> fetchRelations() async {
    for (final field in _fields) {
      if (field.relation.isNotEmpty) {
        switch (relation(field.relation.id)) {
          case Ok(:final value):
            await value.refresh();
          case Err(:final error):
            _log.warning(".fetchRelations | relation '${field.relation}' - not found\n\terror: $error");
        }
      }
    }
  }
}
