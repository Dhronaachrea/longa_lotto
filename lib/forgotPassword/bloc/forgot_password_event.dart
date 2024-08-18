import 'package:flutter/widgets.dart';
import 'package:longa_lotto/forgotPassword/model/request/reset_password_request.dart';

abstract class ForgotPasswordEvent {}

class ForgotPasswordApiEvent extends ForgotPasswordEvent {
  String mobileNo;
  BuildContext context;

  ForgotPasswordApiEvent({required this.context,required this.mobileNo});
}

class ResetPasswordApiEvent extends ForgotPasswordEvent {
  ResetPasswordRequest request;
  BuildContext context;

  ResetPasswordApiEvent({required this.context,required this.request});
}