import 'package:flutter/widgets.dart';

abstract class LogoutEvent {}

class LogoutApiEvent extends LogoutEvent {
  BuildContext context;

  LogoutApiEvent({required this.context});
}
