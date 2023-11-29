import 'package:ext_rw/src/table_schema/schema_write.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class SqlWrite implements SchemaWrite {
  @override
  Future<Result<void, Failure>> delete({entry}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Failure>> insert({entry}) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Failure>> update(entry) {
    // TODO: implement update
    throw UnimplementedError();
  }
}