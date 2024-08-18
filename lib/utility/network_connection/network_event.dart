
import 'package:flutter/cupertino.dart';

abstract class NetworkEvent {}

class IsNetworkConnected extends NetworkEvent {
  BuildContext context;
  bool isConnected;

  IsNetworkConnected({required this.context, required this.isConnected});
}

