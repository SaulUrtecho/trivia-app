import 'package:clean_architecture_tdd_course/core/error/failures.dart';
//import 'package:dartz/dartz.dart';
import 'package:either_dart/either.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return Right<Failure, int>(integer);
    } on FormatException {
      return Left<Failure, int>(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
