
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/profile/model/response/GetBalanceResponse.dart';
import 'package:longa_lotto/profile/model/response/SendVerificationEmailResponse.dart';
import 'package:longa_lotto/profile/repository/profile_repository.dart';
import 'package:longa_lotto/utility/result.dart';
import 'package:longa_lotto/utils/user_info.dart';

class EmailVerifyLogic {
  static Future<Result<dynamic>> callSendVerificationEmailApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> headerSentEmailOtp = {
      "merchantCode" : AppConstants.merchantCode,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await ProfileRepository.callSendVerificationEmailApi(context, request, headerSentEmailOtp);

    try {
      var respObj = SendVerificationEmailResponse.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callVerifyEmailWithOtpApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> headerOtpVerify = {
      "merchantCode" : AppConstants.merchantCode,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await ProfileRepository.callVerifyEmailOtpApi(context, request, headerOtpVerify);

    try {
      var respObj = SendVerificationEmailResponse.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callGetBalanceApi(BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await ProfileRepository.callGetBalanceApi(context, request,);

    try {
      var respObj = GetBalanceResponse.fromJson(jsonMap);
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
}