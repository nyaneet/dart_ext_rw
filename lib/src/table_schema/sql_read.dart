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
    await fetchRelations();
    _sql = _fetchSqlBuilder(values);
    return _fetchWith(_sql);
  }
  ///
  ///
  Future<Result<List<T>, Failure>> fetch(params) {

  }
}