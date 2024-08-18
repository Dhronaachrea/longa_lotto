import 'package:longa_lotto/forgotPassword/model/response/forgot_password_response.dart';
import 'package:longa_lotto/forgotPassword/model/response/reset_password_response.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  String? errorMessage;

  ForgotPasswordError({required this.errorMessage});
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  ForgotPasswordResponse response;

  ForgotPasswordSuccess({required this.response});
}

///////////////////////  RESET PASSWORD  //////////////////

class ResetPasswordError extends ForgotPasswordState {
  String? errorMessage;

  ResetPasswordError({required this.errorMessage});
}

class ResetPasswordSuccess extends ForgotPasswordState {
  ResetPasswordResponse response;

  ResetPasswordSuccess({required this.response});
}