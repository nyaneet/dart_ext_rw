import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class TableSchema<T extends SchemaEntry, P> implements TableSchemaAbstract<T, P> {
  late final Log _log;
  final List<Field> _fields;
  final Map<String, T> _entries = {};
  final SchemaRead<T, P> _read;
  final SchemaWrite<T> _write;
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  TableSchema({
    required List<Field> fields,
    SchemaRead<T, P> read = const SchemaRead.empty(),
    SchemaWrite<T> write = const SchemaWrite.empty(),
  }) :
    _fields = fields,
    _read = read,
    _write = write {
      _log = Log("$runtimeType");
    }
  ///
  /// Returns a list of table field names
  @override
  List<Field> get fields {
    return _fields;
  }
  ///
  /// Returns a list of table field keys
  @override
  List<String> get keys {
    return _fields.map((field) => field.key).toList();
  }
  ///
  ///
  @override
  List<T> get entries => _entries.values.toList();
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(P params) async {
    final read = _read;
    return read.fetch(params).then((result) {
      _log.debug('.fetch | result: $result');
      return switch(result) {
        Ok<List<T>, Failure>(:final value) => () {
          _entries.clear();
          for (final entry in value) {
            if (_entries.containsKey(entry.key)) {
              throw Failure(
                message: "$runtimeType.fetchWith | dublicated entry key: ${entry.key}", 
                stackTrace: StackTrace.current,
              );
            }
            _entries[entry.key] = entry;
          } 
          return Ok<List<T>, Failure>(_entries.values.toList());
        }(),
        Err<List<T>, Failure>(:final error) => () {
          return Err<List<T>, Failure>(error);
        }(),
      };
    });
  }
  ///
  /// Inserts new entry into the table scheme
  @override
  Future<Result<void, Failure>> insert({T? entry}) {
    final write = _write;
    return write.insert(entry).then((result) {
      return switch (result) {
        Ok(:final value) => () {
          final entry_ = value;
          _entries[entry_.key] = entry_;
          return const Ok<void, Failure>(null);
        }(),
        Err(:final error) => Err(error),
      };
    });
  }
  ///
  /// Updates entry of the table scheme
  @override
  Future<Result<void, Failure>> update(T entry) {
    final write = _write;
    return write.update(entry).then((result) {
      if (result is Ok) {
        _entries[entry.key] = entry;
      }
      return result;
    });
  }
  ///
  /// Deletes entry of the table scheme
  @override
  Future<Result<void, Failure>> delete(T entry) {
    final write = _write;
    return write.delete(entry).then((result) {
      if (result is Ok) {
        _entries.remove(entry.key);
      }
      return result;
    });
  }
  //
  //
  @override
  Future<Result<void, Failure>> fetchRelations() {
    return Future.value(
      Err(Failure(
        message: '$runtimeType.fetchRelations | method does not exists', 
        stackTrace: StackTrace.current,
      )),
    );
  }
  //
  //
  @override
  Result<TableSchema<SchemaEntry, dynamic>, Failure> relation(String id) {
    return Err(Failure(
        message: '$runtimeType.relation | method does not exists', 
        stackTrace: StackTrace.current,
    ));
  }
}
