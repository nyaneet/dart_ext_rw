import 'package:ext_rw/src/table_schema/field_value.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestObject {
  final String value;
  const _TestObject(this.value);
}

void main() {
  group('FieldValue update', () {
    test('changes value of the same type if it differs', () {
      const valueMaps = [
        {
          'value': '_+-=()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'new_value': '',
        },
        {
          'value': '',
          'new_value': 'test_str',
        },
        {
          'value': 123,
          'new_value': 394,
        },
        {
          'value': 321.321,
          'new_value': 1.2222222,
        },
        {
          'value': false,
          'new_value': true,
        },
        {
          'value': true,
          'new_value': false,
        },
        {
          'value': _TestObject('1'),
          'new_value': _TestObject('abc'),
        },
        {
          'value': _TestObject('aklsdf'),
          'new_value': _TestObject(''),
        },
      ];
      for(final {'value': value, 'new_value': newValue} in valueMaps) {
        final fieldValue = FieldValue(value);
        expect(fieldValue.value, equals(value));
        expect(fieldValue.update(newValue), equals(true));
        expect(fieldValue.value, equals(newValue));
      }
    });
    test('does not update value if it is the same', () {
      const valueMaps = [
        {
          'value': '_+-=()*&^%\$;:?№"#@!`~\\|/.,[]{}',
          'new_value': '_+-=()*&^%\$;:?№"#@!`~\\|/.,[]{}',
        },
        {
          'value': '',
          'new_value': '',
        },
        {
          'value': 123,
          'new_value': 123,
        },
        {
          'value': 394,
          'new_value': 394,
        },
        {
          'value': 321.321,
          'new_value': 321.321,
        },
        {
          'value': 1.2222222,
          'new_value': 1.2222222,
        },
        {
          'value': false,
          'new_value': false,
        },
        {
          'value': true,
          'new_value': true,
        },
        {
          'value': _TestObject('1'),
          'new_value': _TestObject('1'),
        },
        {
          'value': _TestObject('aklsdf'),
          'new_value': _TestObject('aklsdf'),
        },
      ];
      for(final {'value': value, 'new_value': newValue} in valueMaps) {
        final fieldValue = FieldValue(value);
        expect(fieldValue.value, equals(value));
        expect(fieldValue.update(newValue), equals(false));
        expect(fieldValue.value, equals(value));
      }
    });
  });
}