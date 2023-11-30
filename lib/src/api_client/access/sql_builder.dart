import 'package:ext_rw/src/sql/sql.dart';

typedef SqlBuilder<T> = Sql Function(Sql sql, T entry);
