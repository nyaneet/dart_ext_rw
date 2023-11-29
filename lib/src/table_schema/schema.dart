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
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  Schema({
    required List<Field> fields,
    SchemaRead<T, dynamic>? read,
    SchemaWrite<T>? write,
    Map<String, Schema> relations = const {},
  }) :
    _fields = fields,
    _read = read,
    _write = write,
    _relations = relations {
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
      return read.fetch(params).then((result) {
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
    return Future.value(
      Err<List<T>, Failure>(Failure(
        message: "$runtimeType.fetch | read - not initialized", 
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
  /// Inserts new entry into the table scheme
  Future<Result<void, Failure>> insert({T? entry}) {
    final write = _write;
    if (write != null) {
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
    return Future.value(
      Err(Failure(
        message: "$runtimeType.insert | write - not initialized", 
        stackTrace: StackTrace.current,
      )),
    );
  }
  ///
  /// Updates entry of the table scheme
  Future<Result<void, Failure>> update(T entry) {
    final write = _write;
    if (write != null) {
      return write.update(entry).then((result) {
        if (result is Ok) {
          _entries[entry.key] = entry;
        }
        return result;
      });
    }
    return Future.value(
      Err<List<T>, Failure>(Failure(
        message: "$runtimeType.update | write - not initialized", 
        stackTrace: StackTrace.current,
      )),
    );
  }
  ///
  /// Deletes entry of the table scheme
  Future<Result<void, Failure>> delete(T entry) {
    final write = _write;
    if (write != null) {
      return write.delete(entry).then((result) {
        if (result is Ok) {
          _entries.remove(entry.key);
        }
        return result;
      });
    }
    return Future.value(
      Err<List<T>, Failure>(Failure(
        message: "$runtimeType.delete | write - not initialized", 
        stackTrace: StackTrace.current,
      )),
    );
  }
  ///
  /// Fetchs data of the relation schemes only (with existing sql)
  Future<void> fetchRelations() async {
    for (final field in _fields) {
      if (field.relation.isNotEmpty) {
        switch (relation(field.relation.id)) {
          case Ok(:final value):
            await value.fetch(null);
          case Err(:final error):
            _log.warning(".fetchRelations | relation '${field.relation}' - not found\n\terror: $error");
        }
      }
    }
  }
}
