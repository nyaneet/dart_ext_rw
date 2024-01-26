
import 'package:ext_rw/src/table_schema/relation.dart';

///
/// Replresentation settings for table column
class Field {
  final String _key;
  final String _title;
  final bool _hidden;
  final bool _edit;
  final Relation _relation;
  ///
  /// **Represents table column settings**
  /// - [title] - display name of the column, if null, the [key] will be displayed
  /// - [key] 
  ///   - database column name if not relation
  ///   - relation key if this is relation column
  /// - [relation] - represents column, related from another table, where from data will be gotten
  const Field({
    required String key,
    String? title,
    bool hidden = false,
    bool editable = true,
    Relation? relation,
  }) :
    _key = key,
    _title = title ?? key,
    _hidden = hidden,
    _edit = editable,
    _relation = relation ?? const Relation.empty();
  ///
  ///
  String get key => _key;
  ///
  ///
  String get title => _title;
  ///
  ///
  bool get isHidden => _hidden;
  ///
  ///
  bool get isEditable => _edit;
  ///
  ///
  Relation get relation => _relation;
  //
  //
  @override
  String toString() {
    return '$runtimeType{ key: $_key, title: $_title, hidden: $_hidden, editable: $_edit, relation: $_relation }';
  }
}