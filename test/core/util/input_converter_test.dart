import 'package:clean_architecture_tdd_course/core/error/failures.dart';
import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when the string represents an unsigned integer', () async {
      const str = '123';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, const Right<Failure, int>(123));
    });

    test('should return a Failure when the string is not a integer', () async {
      const str = '0.5';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string a negative integer', () async {
      const str = '-123';
      final result = inputConverter.stringToUnsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
