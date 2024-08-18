import 'package:flutter/cupertino.dart';

abstract class LoginEvent {}

class LoginPlayerEvent extends LoginEvent {
  String userName;
  String password;
  BuildContext context;

  LoginPlayerEvent({required this.context, required this.userName, required this.password});
}

class GetInbox extends LoginEvent {
  final int offset;
  final bool isPagination;
  final BuildContext context;

  GetInbox({
    required this.offset,
    this.isPagination = false,
    required this.context,
  });
}
