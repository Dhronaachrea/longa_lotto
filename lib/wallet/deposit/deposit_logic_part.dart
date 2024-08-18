import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/utility/result.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/deposit/model/response/GetStatusFromProviderTxnResponse.dart';
import 'package:longa_lotto/wallet/deposit/repository/deposit_repository.dart';

class DepositLogic {
  static Future<Result<dynamic>> callPaymentOptionsApi(BuildContext context, Map<String, dynamic> request) async {
    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode
    };
    dynamic jsonMap = await DepositRepository.callPaymentOptionsApi(context, request, header);
    try {
      // var respObj = DepositResponse.fromJson(jsonMap);
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

  static Future<Result<dynamic>> callConvertToPgCurrencyApi(BuildContext context, Map<String, dynamic> request) async {

    Map<String, dynamic> header = {
      "merchantCode" : AppConstants.merchantCode,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await DepositRepository.callConvertToPgCurrencyApi(context, request, header);
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

  static Future<Result<dynamic>> callGetStatusFromProviderTxnApi(BuildContext context, Map<String, dynamic> request) async {

    Map<String, dynamic> header = {
      "playerToken": UserInfo.userToken,
    };

    dynamic jsonMap = await DepositRepository.callGetStatusFromProviderTxnApi(context, request, header);
    try {
      var respObj = GetStatusFromProviderTxnResponse.fromJson(jsonMap);
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