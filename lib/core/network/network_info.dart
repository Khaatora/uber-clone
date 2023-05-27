import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class INetworkInfo{
  Future<bool> get isConnected;
}

class ICCNetworkInfo implements INetworkInfo{
  final InternetConnectionChecker internetConnectionChecker;


  ICCNetworkInfo(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}