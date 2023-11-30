import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class RelationSchema<T extends SchemaEntry, P> implements Schema<T, P> {
  late final Log _log;
  final TableSchema<T, P> _tableSchema;
  final Map<String, TableSchema> _relations;
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  RelationSchema({
    required TableSchema<T, P> tableSchema,
    Map<String, TableSchema> relations = const {},
  }) :
    _tableSchema = tableSchema,
    _relations = relations {
      _log = Log("$runtimeType");
    }
  ///
  /// Returns a list of table field names
  List<Field> get fields {
    return _tableSchema.fields;
  }
  ///
  /// Returns a list of table field keys
  List<String> get keys {
    return _tableSchema.keys;
  }
  ///
  ///
  List<T> get entries => _tableSchema.entries;
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(params) async {
    await fetchRelations();
    return _tableSchema.fetch(params);
  }
  ///
  /// Returns relation Result<Scheme> if exists else Result<Failure>
  Result<TableSchema, Failure> relation(String id) {
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
  @override
  Future<Result<void, Failure>> insert({T? entry}) {
    return _tableSchema.insert(entry: entry);
  }
  ///
  /// Updates entry of the table scheme
  @override
  Future<Result<void, Failure>> update(T entry) {
    return _tableSchema.update(entry);
  }
  ///
  /// Deletes entry of the table scheme
  @override
  Future<Result<void, Failure>> delete(T entry) {
    return _tableSchema.delete(entry);
  }
  ///
  /// Fetchs data of the relation schemes only (with existing sql)
  Future<void> fetchRelations() async {
    for (final field in _tableSchema.fields) {
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
