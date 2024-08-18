import 'package:longa_lotto/sign_up/model/response/registration_response.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState{}

class LoginSuccess extends LoginState{
  RegistrationResponse? response;

  LoginSuccess({required this.response});

}
class LoginError extends LoginState{
  String errorMessage;

  LoginError({required this.errorMessage});
}

