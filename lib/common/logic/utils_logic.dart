import 'package:flutter/material.dart';
import 'package:longa_lotto/common/model/response/get_balance_response.dart';
import 'package:longa_lotto/common/model/response/logout_response.dart';
import 'package:longa_lotto/common/repository/utils_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class UtilsLogic {
  static Future<Result<dynamic>> getBalanceApi(
      BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await UtilsRepository.getBalanceApi(context, request);
    try {
      var respObj = GetBalanceResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callLogoutApi(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await UtilsRepository.logOutApi(context, request);
    try {
      var respObj = LogoutResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

}
