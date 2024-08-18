import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/sign_up/model/response/check_availability_response.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/sign_up/model/response/send_reg_otp_response.dart';
import 'package:longa_lotto/sign_up/repository/sign_up_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class SignUpLogic {
  static Future<Result<dynamic>> callCheckAvailabilityApi(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await SignUpRepository.callCheckAvailabilityApi(context, request);
    try {
      var respObj = CheckAvailabilityResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callSendRegOtpApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };
    dynamic jsonMap = await SignUpRepository.callSendRegOtpApi(context, request, header);

    try {
      var respObj = SendRegOtpResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }

  }

  static Future<Result<dynamic>> callRegistrationApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };

    dynamic jsonMap = await SignUpRepository.callRegistrationApi(context, request, header);

    try {
      var respObj = RegistrationResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callRegistrationWithScannerApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };

    dynamic jsonMap = await SignUpRepository.callRegistrationWithScannerApi(context, request, header);

    try {
      var respObj = RegistrationResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);

      } else {
        return Result.responseFailure(data: respObj);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}