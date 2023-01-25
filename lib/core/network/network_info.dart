import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// this class implements above class which has a Future getter of boolean type
class NetworkInfoImpl implements NetworkInfo {
  // we create a InternetConnectionChecker variable for
  // access to hasConnection getter.
  final InternetConnectionChecker connectionChecker;
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
