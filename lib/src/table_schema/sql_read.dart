import 'package:ext_rw/ext_rw.dart';
import 'package:ext_rw/src/table_schema/schema_read.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SqlRead<T extends SchemaEntry> implements SchemaRead {
  late final Log _log;
  final ApiAddress _address;
  final String _authToken;
  final String _database;
  final bool _keepAlive;
  final bool _debug;
  final Sql Function(List<dynamic>? values) _fetchSqlBuilder;
  final Map<String, T> _entries = {};
  Sql _sql = Sql(sql: '');
  ///
  ///
  SqlRead({
    required ApiAddress address,
    required String authToken,
    required String database,
    bool keepAlive = false,
    bool debug = false,
    required Sql Function(List<dynamic>? values) fetchSqlBuilder,
  }) :
    _address = address,
    _authToken = authToken,
    _database = database,
    _keepAlive = keepAlive,
    _debug = debug,
    _fetchSqlBuilder = fetchSqlBuilder {
    _log = Log("$runtimeType");
  }
  ///
  ///
  @override
  Future<Result<List<T>, Failure>> fetch(params) {
    _sql = _fetchSqlBuilder(params);
    return _fetchWith(_sql);
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