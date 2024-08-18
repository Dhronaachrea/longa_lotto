import 'package:flutter/material.dart';
import 'package:longa_lotto/inbox/model/response/inbox_response.dart';
import 'package:longa_lotto/inbox/repository/inbox_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class InboxLogic {
  static Future<Result<dynamic>> callInbox(
      BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await InboxRepository.callInbox(context, request);
    try {
      InboxResponseModel respObj = InboxResponseModel.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callInboxActivity(
      BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await InboxRepository.callInboxActivity(context, request);
    try {
      InboxResponseModel respObj = InboxResponseModel.fromJson(jsonMap);
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
