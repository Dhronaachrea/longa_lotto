
import 'package:longa_lotto/changePassword/model/response/change_password_response.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  String? errorMessage;
  ChangePasswordError({required this.errorMessage});
}

class ChangePasswordSuccess extends ChangePasswordState {
  ChangePasswordResponse? response;

  ChangePasswordSuccess({required this.response});
}

