import 'package:flutter/widgets.dart';

abstract class ChangePasswordEvent {}

class ChangePasswordApiEvent extends ChangePasswordEvent {
  BuildContext context;
  String oldPassword;
  String newPassword;

  ChangePasswordApiEvent({required this.context, required this.oldPassword, required this.newPassword});
}
