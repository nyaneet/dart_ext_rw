import 'package:ext_rw/src/table_schema/field_value.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestObject {
  const _TestObject();
}

void main() {
  group('FieldValue constructor', () {
    test('sets default values with only required parameters provided', () {
      const values = [3456, 0, -124 -2345.56, 0.0, 234111.0, 'abc', '', true, _TestObject()];
      for(final value in values) {
        final fieldValue = FieldValue('$value');
        expect(fieldValue.value, equals('$value'));
        expect(fieldValue.type, equals(FieldType.string));
      }
    });
    test('sets provided arguments', () {
      const valueMaps = [
        {
          'value': '_+-+()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'type': FieldType.string,
        },
        {
          'value': '_+-+()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'type': FieldType.string,
        },
        {
          'value': '_+-+()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'type': FieldType.string,
        },
        {
          'value': '_+-+()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'type': FieldType.string,
        },
        {
          'value': 123,
          'type': FieldType.string,
        },
        {
          'value': 123,
          'type': FieldType.int,
        },
        {
          'value': 123,
          'type': FieldType.double,
        },
        {
          'value': 123,
          'type': FieldType.bool,
        },
        {
          'value': 321.321,
          'type': FieldType.string,
        },
        {
          'value': 321.321,
          'type': FieldType.int,
        },
        {
          'value': 321.321,
          'type': FieldType.double,
        },
        {
          'value': 321.321,
          'type': FieldType.bool,
        },
        {
          'value': false,
          'type': FieldType.string,
        },
        {
          'value': false,
          'type': FieldType.int,
        },
        {
          'value': false,
          'type': FieldType.double,
        },
        {
          'value': false,
          'type': FieldType.bool,
        },
        {
          'value': null,
          'type': FieldType.string,
        },
        {
          'value': null,
          'type': FieldType.int,
        },
        {
          'value': null,
          'type': FieldType.double,
        },
        {
          'value': null,
          'type': FieldType.bool,
        },
        {
          'value': _TestObject(),
          'type': FieldType.string,
        },
        {
          'value': _TestObject(),
          'type': FieldType.int,
        },
        {
          'value': _TestObject(),
          'type': FieldType.double,
        },
        {
          'value': _TestObject(),
          'type': FieldType.bool,
        },
      ];
      for(final {'value': value, 'type': type as FieldType} in valueMaps) {
        final fieldValue = FieldValue(value, type: type);
        expect(fieldValue.value, equals(value));
        expect(fieldValue.type, equals(type));
      }
    });
  });
}