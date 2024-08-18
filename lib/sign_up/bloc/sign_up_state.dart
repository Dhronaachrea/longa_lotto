import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/sign_up/model/response/send_reg_otp_response.dart' as sendRegOtp;

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class CheckMobileNoAvailabilityError extends SignUpState {
  String? errorMessage;
  int? errorCode;

  CheckMobileNoAvailabilityError({required this.errorMessage, this.errorCode});
}

class CheckMobileNoAvailabilitySuccess extends SignUpState {

  CheckMobileNoAvailabilitySuccess();
}
////////////////////  Send Otp ///////////////////////////////////
class SendRegOtpSuccess extends SignUpState {
  sendRegOtp.Data? response;

  SendRegOtpSuccess({required this.response});
}
class SendRegOtpError extends SignUpState {
  String? errorMessage;

  SendRegOtpError({required this.errorMessage});
}

/////////////////// Registration and verify otp ////////////////////
class RegistrationLoading extends SignUpState {}

class RegistrationSuccess extends SignUpState {
  RegistrationResponse? response;

  RegistrationSuccess({required this.response});
}
class RegistrationError extends SignUpState {
  String errorMessage;

  RegistrationError({required this.errorMessage});
}