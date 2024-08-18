import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:longa_lotto/utility/network_connection/network_event.dart';

import 'network_connection/network_bloc.dart';

class NetworkSingleton{

  static final NetworkSingleton _networkSingleton = NetworkSingleton._instance();

  factory NetworkSingleton() {
    return _networkSingleton;
  }

  NetworkSingleton._instance();

  var listener;

  setNetworkListener(BuildContext context) {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');

          BlocProvider.of<NetworkBloc>(context).add(IsNetworkConnected(context: context, isConnected: true));
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');

          BlocProvider.of<NetworkBloc>(context).add(IsNetworkConnected(context: context, isConnected: false));
          break;
      }
    });

    listener.resume();
  }

}