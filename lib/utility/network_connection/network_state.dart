
abstract class NetworkState {}

class NetworkInitial extends NetworkState {}

class NetWorkConnected extends NetworkState {
  String s;
  NetWorkConnected({required this.s});
}

class NetWorkNotConnected extends NetworkState {
  String s;

  NetWorkNotConnected({required this.s});
}

