import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<DataConnectionCheckerTest>()])
import 'network_info_test.mocks.dart';

class DataConnectionCheckerTest extends Mock implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfo;
  late MockDataConnectionCheckerTest mockDataConnectionCheckerTest;

  setUp(() {
    mockDataConnectionCheckerTest = MockDataConnectionCheckerTest();
    networkInfo = NetworkInfoImpl(mockDataConnectionCheckerTest);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionCheckerTest.hasConnection).thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo.isConnected;

      verify(mockDataConnectionCheckerTest.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
