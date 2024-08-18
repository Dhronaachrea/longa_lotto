import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/forgotPassword/model/response/forgot_password_response.dart';
import 'package:longa_lotto/forgotPassword/model/response/reset_password_response.dart';
import 'package:longa_lotto/forgotPassword/repository/forgot_password_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class ForgotPasswordLogic {
  static Future<Result<dynamic>> callForgotPasswordApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };
    dynamic jsonMap = await ForgotPasswordRepository.callForgotPasswordApi(context, request, header);
    try {
      var respObj = ForgotPasswordResponse.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callResetPasswordApi(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await ForgotPasswordRepository.callResetPasswordApi(context, request);
    try {
      var respObj = ResetPasswordResponse.fromJson(jsonMap);
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