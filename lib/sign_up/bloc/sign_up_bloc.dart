import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_event.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_state.dart';
import 'package:longa_lotto/sign_up/model/request/check_availability_request.dart';
import 'package:longa_lotto/sign_up/model/request/registration_request.dart';
import 'package:longa_lotto/sign_up/model/request/send_reg_otp_request.dart';
import 'package:longa_lotto/sign_up/model/response/check_availability_response.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/sign_up/model/response/send_reg_otp_response.dart';
import 'package:longa_lotto/sign_up/sign_up_logic_part/sign_up_logic_part.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/utils.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<CheckMobileNoAvailabilityBeforeRegisteringEvent>(_onCheckMobileNoAvailabilityEvent);
    on<SendRegOtpEvent>(_onSendRegOtpEvent);
    on<RegistrationEvent>(_onRegistrationEvent);
    on<RegistrationUsingScan>(_onRegistrationUsingScanEvent);
  }
}

_onCheckMobileNoAvailabilityEvent(CheckMobileNoAvailabilityBeforeRegisteringEvent event, Emitter<SignUpState> emit) async {
  emit(SignUpLoading());
  String mobileNumber  = event.mobileNo;
  String userName  = event.userName;
  BuildContext context = event.context;

  var response = await SignUpLogic.callCheckAvailabilityApi(context, CheckAvailabilityRequest(mobileNo: mobileNumber, domainName: AppConstants.domainName, userName: userName).toJson());

  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(CheckMobileNoAvailabilityError(errorMessage: context.l10n.not_internet_connection));

    }, responseSuccess: (value) {
          emit(CheckMobileNoAvailabilitySuccess());
    }, responseFailure: (value) {
      print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
      CheckAvailabilityResponse errorResponse = value as CheckAvailabilityResponse;
      emit(CheckMobileNoAvailabilityError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
     /* emit(CheckMobileNoAvailabilityError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value?.errorCode
      ));*/

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(CheckMobileNoAvailabilityError(errorMessage: context.l10n.not_internet_connection));
      } else {
        emit(CheckMobileNoAvailabilityError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
      }
    });

  } catch(e) {
    emit(CheckMobileNoAvailabilityError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }
}

_onSendRegOtpEvent(SendRegOtpEvent event, Emitter<SignUpState> emit) async {
  BuildContext context = event.context;
  String mobileNo = event.mobileNo;

  var response = await SignUpLogic.callSendRegOtpApi(context,
      SendRegOtpRequest(aliasName: AppConstants.domainName, mobileNo: mobileNo)
          .toJson());

  try {
    response.when(idle: () {

    },
        networkFault: (value) {
          emit(SendRegOtpError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          SendRegOtpResponse successResponse = value as SendRegOtpResponse;
          emit(SendRegOtpSuccess(response: successResponse.data));
        },
        responseFailure: (value) {
          print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
          SendRegOtpResponse errorResponse = value as SendRegOtpResponse;
          emit(SendRegOtpError(
              errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse.errorCode)));
          /*emit(SendRegOtpError(errorMessage: value?.respMsg ??
              context.l10n.something_went_wrong_while_extracting_response));*/
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
            emit(SendRegOtpError(errorMessage: context.l10n.not_internet_connection));
          } else {
            emit(SendRegOtpError(
                errorMessage: value["occurredErrorDescriptionMsg"] ??
                    context.l10n.something_went_wrong));
          }
        });
  } catch (e) {
    emit(CheckMobileNoAvailabilityError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }
}

_onRegistrationEvent(RegistrationEvent event, Emitter<SignUpState> emit) async{
    emit(RegistrationLoading());
    BuildContext context          = event.context;
    RegistrationRequest request   = event.request;

    var response = await SignUpLogic.callRegistrationApi(context, request.toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(RegistrationError(errorMessage: value["occurredErrorDescriptionMsg"]));

      }, responseSuccess: (value) {
        RegistrationResponse successResponse = value as RegistrationResponse;
        BlocProvider.of<AuthBloc>(context).add(
          UserLogin(registrationResponse: successResponse),
        );
        emit(RegistrationSuccess(response: successResponse));

      }, responseFailure: (value) {
        RegistrationResponse? errorResponse = value as RegistrationResponse?;
        print("bloc responseFailure: ${errorResponse?.errorCode}, ${errorResponse?.errorMessage}");
        emit(RegistrationError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse?.errorCode)));
        //emit(RegistrationError(errorMessage: errorResponse?.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(RegistrationError(errorMessage: context.l10n.not_internet_connection));
        } else {
          emit(RegistrationError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });
    } catch(e) {
      print("error=========> $e");
      emit(CheckMobileNoAvailabilityError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

}

FutureOr<void> _onRegistrationUsingScanEvent(RegistrationUsingScan event, Emitter<SignUpState> emit) async {
  BuildContext context = event.context;
  emit(RegistrationLoading());

  /*RegistrationRequest(
      countryCode: AppConstants.countryCode,
      currencyCode: AppConstants.currencyCode,
      domainName: AppConstants.domainName,
      deviceType: AppConstants.deviceType,
      emailId: null,
      loginDevice: "ANDROID_APP_CASH",
      mobileNo: widget.userEnteredInfo["mobileNo"],
      userName: widget.userEnteredInfo["userName"],
      otp: otpController.text.trim(),
      password: widget.userEnteredInfo["password"],
      registrationType: "FULL",
      requestIp: AppConstants.requestIp,
      userAgent: AppConstants.userAgent,
      referCode: widget.userEnteredInfo["referCode"],
      referSource: widget.userEnteredInfo["referCode"] != "" ? "REFER_FRIEND" : ""
  )*/

  var request  = {
    "countryCode": event.countryCode,
    "currencyCode": event.currencyCode,
    "loginDevice": Platform.isAndroid
        ? AppConstants.androidLoginDevice
        : AppConstants.iosLoginDevice,
    "userName": event.username,
    "hitFromCashier": true,
    "requestIp": AppConstants.requestIp,
    "aliasName": "www.scanplay-longagames.com",
    "domainName": "www.scanplay-longagames.com",
    "deviceType": AppConstants.deviceType,//"MOBILE_WEB",
    "userAgent": AppConstants.userAgent
  };

  /*var request = {
    "countryCode": event.countryCode,
    "currencyCode": event.currencyCode,
    "deviceType": AppConstants.deviceType,
    "domainName": AppConstants.domainName,
    "aliasName": AppConstants.domainName,
    "userName": event.username,
    "hitFromCashier": true,
    "loginDevice": Platform.isAndroid
        ? AppConstants.androidLoginDevice
        : AppConstants.iosLoginDevice,
    "requestIp": AppConstants.requestIp,
    "userAgent": AppConstants.userAgent
  };*/
  var response = await SignUpLogic.callRegistrationWithScannerApi(context, request);

  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(RegistrationError(errorMessage: value["occurredErrorDescriptionMsg"]));

    }, responseSuccess: (value) {
      RegistrationResponse successResponse = value as RegistrationResponse;
      BlocProvider.of<AuthBloc>(context).add(
        UserLogin(registrationResponse: successResponse),
      );
      successResponse.ramPlayerInfo?.aliasName = "www.scanplay-longagames.com";
      emit(RegistrationSuccess(response: successResponse));

    }, responseFailure: (value) {
      RegistrationResponse? errorResponse = value as RegistrationResponse?;
      print("bloc responseFailure: ${errorResponse?.errorCode}, ${errorResponse?.errorMessage}");
      emit(RegistrationError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, errorResponse?.errorCode)));
      //emit(RegistrationError(errorMessage: errorResponse?.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(RegistrationError(errorMessage: context.l10n.not_internet_connection));
      } else {
        emit(RegistrationError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
      }
    });
  } catch(e) {
    print("error=========> $e");
    emit(CheckMobileNoAvailabilityError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }
}


