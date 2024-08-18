import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/ticket/model/response/tIcket_response.dart';
import 'package:longa_lotto/ticket/respository/ticket_repository.dart';
import 'package:longa_lotto/utility/result.dart';

class TicketLogic {
  static Future<Result<dynamic>> getTicketList(BuildContext context, Map<String, dynamic> request) async {
    dynamic jsonMap = await TicketRepository.getTicketList(context, request);
    try {
      var respObj = TicketResponse.fromJson(jsonMap);
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