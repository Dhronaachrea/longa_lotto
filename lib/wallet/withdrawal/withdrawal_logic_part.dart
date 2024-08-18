import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/utility/result.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/withdrawal/model/response/WithdrawalRequestResponse.dart';
import 'package:longa_lotto/wallet/withdrawal/repository/withdrawal_repository.dart';

class WithdrawalLogic {
  static Future<Result<dynamic>> callPaymentOptionsApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };
    dynamic jsonMap = await WithdrawalRepository.callPaymentOptionsApi(context, request, header);
    try {
      // var respObj = PaymentOptionsResponse.fromJson(jsonMap);
      if (jsonMap["errorCode"] == 0) {
        return Result.responseSuccess(data: jsonMap);

      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap["occurredErrorDescriptionMsg"] == "No connection" ? Result.networkFault(data: jsonMap) : Result.failure(data: jsonMap) : Result.responseFailure(data: jsonMap);
      }

    } catch(e) {
      if(jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);

      } else {
        return Result.failure(data: jsonMap["occurredErrorDescriptionMsg"] != null ? jsonMap : {"occurredErrorDescriptionMsg": e});
      }
    }
  }

  static Future<Result<dynamic>> callWithdrawalRequestApi(BuildContext context, Map<String, dynamic> request) async {

    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await WithdrawalRepository.callWithdrawalRequestApi(context, request, header);
    try {
      var respObj = WithdrawalRequestResponse.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callConvertToPgCurrencyApi(BuildContext context, Map<String, dynamic> request) async {

    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await WithdrawalRepository.callConvertToPgCurrencyApi(context, request, header);
    try {
      var respObj = ConvertToPgCurrencyResponse.fromJson(jsonMap);
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