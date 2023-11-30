import 'package:ext_rw/ext_rw.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

///
/// A collection of the SchameEntry, 
/// abstruction on the table rows
abstract interface class TableSchemaAbstract<T extends SchemaEntry, P> implements Schema<T, P> {
  ///
  /// Returns a list of table field names
  List<Field> get fields;
  ///
  /// Returns a list of table field keys
  List<String> get keys;
  ///
  ///
  List<T> get entries;
  ///
  /// Fetchs data with new sql built from [values]
  @override
  Future<Result<List<T>, Failure>> fetch(params);
  ///
  /// Returns relation Result<Scheme> if exists else Result<Failure>
  Result<TableSchemaAbstract, Failure> relation(String id);
  ///
  /// Inserts new entry into the table scheme
  @override
  Future<Result<void, Failure>> insert({T? entry});
  ///
  /// Updates entry of the table scheme
  @override
  Future<Result<void, Failure>> update(T entry);
  ///
  /// Deletes entry of the table scheme
  @override
  Future<Result<void, Failure>> delete(T entry);
  ///
  /// Fetchs data of the relation schemes only (with existing sql)
  Future<Result<void, Failure>> fetchRelations();
}
