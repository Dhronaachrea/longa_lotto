

import 'package:longa_lotto/common/model/response/logout_response.dart';

abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutError extends LogoutState {
  String? errorMessage;

  LogoutError({required this.errorMessage});
}

class LogoutSuccess extends LogoutState {
  LogoutResponse response;
  LogoutSuccess({required this.response});
}
