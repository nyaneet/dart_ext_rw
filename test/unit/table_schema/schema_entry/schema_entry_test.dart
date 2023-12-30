import 'package:ext_rw/src/table_schema/field_value.dart';
import 'package:ext_rw/src/table_schema/schema_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';

void main() {
  Log.initialize(level: LogLevel.all);
  const log = Log('SchemaEntry');
  group('SchemaEntry', () {
    Map<String, Map<String, FieldValue<dynamic>>> testData_() {
      final initial = {
        'key00': {'first': FieldValue(false), 'second': FieldValue(true)},
        'key01': {'first': FieldValue(true), 'second': FieldValue(false)},
        'key1': {'first': FieldValue('key1'), 'second': FieldValue('1key1')},
        'key2': {'first': FieldValue(0.123), 'second': FieldValue(0.456)},
        'key3': {'first': FieldValue(123), 'second': FieldValue(456)},
        'key4': {'first': FieldValue(-123), 'second': FieldValue(456)},
        'key5': {'first': FieldValue(123), 'second': FieldValue(-456)},
      };
      return initial;
    }
    test('value()', () {
      final initial = testData_().map((key, value) => MapEntry(key, value['first']));
      final entry = SchemaEntry(map: initial.cast());
      for (final MapEntry(:key, :value) in initial.entries) {
        expect(entry.value(key), equals(value));
      }
    });
    test('update()', () {
      final testData = testData_();
      final initial = testData.map((key, value) => MapEntry(key, value['first']));
      final entry = SchemaEntry(map: initial.cast());
      for (final MapEntry(:key, :value) in testData.entries) {
        final {'first': first, 'second': second} = value;
        log.debug('first: $first, second: $second}');
        expect(entry.value(key), equals(first));
        log.debug('key: $key, fieldValue: ${entry.value(key)}');
        entry.update(key, second.value);
        // expect(entry.value(key), equals(second));
      }
    });
  });
}
