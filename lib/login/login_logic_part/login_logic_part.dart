
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/login/repository/login_repository.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utility/result.dart';

class LoginLogic {
    static Future<Result<dynamic>> callLoginApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };

    dynamic jsonMap = await LoginRepository.callLoginApi(context, request, header);

    try {
      var respObj = RegistrationResponse.fromJson(jsonMap);
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