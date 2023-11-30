import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
/// A collection of the SchameEntry, 
/// abstruction on the SQL table rows
class RelationSchema<T extends SchemaEntry, P> implements Schema<T, P> {
  late final Log _log;
  final TableSchemaAbstract<T, P> _schema;
  final Map<String, TableSchemaAbstract> _relations;
  ///
  /// A collection of the SchameEntry, 
  /// abstruction on the SQL table rows
  /// - [keys] - list of table field names
  RelationSchema({
    required TableSchemaAbstract<T, P> schema,
    Map<String, TableSchemaAbstract> relations = const {},
  }) :
    _schema = schema,
    _relations = relations {
      _log = Log("$runtimeType");
    }
  ///
  /// Returns a list of table field names
  List<Field> get fields {
    return _schema.fields;
  }
  ///
  /// Returns a list of table field keys
  List<String> get keys {
    return _schema.keys;
  }
  ///
  ///
  List<T> get entries => _schema.entries;
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(params) async {
    await fetchRelations();
    return _schema.fetch(params);
  }
  ///
  /// Returns relation Result<Scheme> if exists else Result<Failure>
  Result<TableSchemaAbstract, Failure> relation(String id) {
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
    return _schema.insert(entry: entry);
  }
  ///
  /// Updates entry of the table scheme
  @override
  Future<Result<void, Failure>> update(T entry) {
    return _schema.update(entry);
  }
  ///
  /// Deletes entry of the table scheme
  @override
  Future<Result<void, Failure>> delete(T entry) {
    return _schema.delete(entry);
  }
  ///
  /// Fetchs data of the relation schemes only (with existing sql)
  Future<void> fetchRelations() async {
    for (final field in _schema.fields) {
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
