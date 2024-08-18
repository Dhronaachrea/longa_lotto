import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/repository/dashboard_repository.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utility/result.dart';
import 'package:longa_lotto/utils/user_info.dart';

class DashBoardLogic {
  static Future<Result<dynamic>> callCheckBonusStatusPlayerApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode"  : AppConstants.merchantCode,
      "merchantPwd"   : AppConstants.merchantPwd,
      "playerId"      : UserInfo.userId,
      "playerToken"   : UserInfo.userToken
    };

    dynamic jsonMap = await DashBoardRepository.callCheckBonusStatusPLayerApi(context, request, header);

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