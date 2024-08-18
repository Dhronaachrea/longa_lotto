import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

extension NetworkConnection on Dio {
  isNetworkConnected() async{
    var isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }
}