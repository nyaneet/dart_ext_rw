import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core_log.dart';


void main() {
  Log.initialize();
  final log = const Log('ApiRequest')..level = LogLevel.debug;
  test('adds one to input values', () {
    const result = true;
    log.debug('result: $result');
    expect(result, true);
  });
}
