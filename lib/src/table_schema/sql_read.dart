import 'package:ext_rw/src/table_schema/schema_read.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SqlRead implements SchemaRead {
  @override
  Future<Result<List, Failure>> fetch(params) {
    // TODO: implement fetch
    throw UnimplementedError();
  }
}