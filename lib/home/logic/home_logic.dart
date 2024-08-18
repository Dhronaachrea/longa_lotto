import 'package:flutter/material.dart';
import 'package:longa_lotto/home/repository/home_repository.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/utility/result.dart';

class HomeLogic {
  static Future<Result<dynamic>> callFetchDgeGame(
      BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await HomeRepository.callFetchDgeGame(context, request);
    try {
      DgeGameResponse respObj = DgeGameResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
                ? Result.networkFault(data: jsonMap)
                : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
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

  static Future<Result<dynamic>> callFetchIgeGame(
      BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await HomeRepository.callFetchIgeGame(context, request);
    try {
      IgeGameResponse respObj = IgeGameResponse.fromJson(jsonMap);
      if (respObj.success ?? false) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
                ? Result.networkFault(data: jsonMap)
                : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
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
