import 'package:flutter/material.dart';
import 'package:longa_lotto/splash/model/response/VersionControlResponse.dart';
import 'package:longa_lotto/splash/repository/splash_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class SplashLogic{
  static Future<Result<dynamic>> callVersionControlApi(
      BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await SplashRepository.callVersionControlApi(context, request);
    try {
      VersionControlResponse respObj = VersionControlResponse.fromJson(jsonMap);
      if (respObj.errorCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return Result.responseFailure(data: respObj);
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
}