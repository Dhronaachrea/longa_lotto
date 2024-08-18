import 'package:flutter/widgets.dart';
import 'package:longa_lotto/sign_up/model/request/registration_request.dart';

abstract class SignUpEvent {}

class CheckMobileNoAvailabilityBeforeRegisteringEvent extends SignUpEvent {
  String mobileNo;
  String userName;
  BuildContext context;

  CheckMobileNoAvailabilityBeforeRegisteringEvent({required this.context,required this.mobileNo, required this.userName});
}

class SendRegOtpEvent extends SignUpEvent {
  String mobileNo;
  BuildContext context;

  SendRegOtpEvent({required this.context, required this.mobileNo});
}

class RegistrationEvent extends SignUpEvent {
  BuildContext context;
  RegistrationRequest request;

  RegistrationEvent({required this.context, required this.request});
}

class RegistrationUsingScan extends SignUpEvent {
  final String username;
  final String currencyCode;
  final String countryCode;
  final BuildContext context;

  RegistrationUsingScan({
    required this.username,
    required this.context,
    required this.currencyCode,
    required this.countryCode,
  });
}
