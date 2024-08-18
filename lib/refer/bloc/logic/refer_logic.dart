import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/model/response/track_status_response.dart';
import 'package:longa_lotto/refer/repository/refer_a_friend_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class ReferLogic{
  static Future<Result<dynamic>> callTrackStatusApi(
      BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await ReferAFriendRepository.callTrackStatusApi(context, request);
    try {
      TrackStatusResponseModel respObj = TrackStatusResponseModel.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callInviteFriendApi(
      BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await ReferAFriendRepository.callInviteFriendApi(context, request);
    try {
      TrackStatusResponseModel respObj = TrackStatusResponseModel.fromJson(jsonMap);
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