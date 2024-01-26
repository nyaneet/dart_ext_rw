import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:ext_rw/src/table_schema/schema_entry_abstract.dart';

///
/// - hosds simple SQL
/// - alows to build sql with multiple values
class Sql {
  ///
  final String _sql;
  final List<SchemaEntryAbstract> _enties;
  ///
  Sql({
    required String sql,
    List<SchemaEntry> values = const [],
  }) :
    _sql = sql,
    _enties = values;
  ///
  /// adding values to the sql
  void addValues(SchemaEntryAbstract entry) {
    _enties.add(entry);
  }
  /// 
  ///
  String build() {
    return _sql;
  }
}