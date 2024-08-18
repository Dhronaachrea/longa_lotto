import 'package:flutter/widgets.dart';
import 'package:longa_lotto/changePassword/model/response/change_password_response.dart';
import 'package:longa_lotto/changePassword/repository/change_password_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class ChangePasswordLogic {
  static Future<Result<dynamic>> callChangePasswordApi(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await ChangePasswordRepository.callChangePasswordApi(context, request);
    try {
      var respObj = ChangePasswordResponse.fromJson(jsonMap);
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