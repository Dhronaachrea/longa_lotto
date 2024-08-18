import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class WithdrawalRepository {
  static dynamic callPaymentOptionsApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.cashierBaseUrl, MethodType.post, ApiUrlsConstant.paymentOptionsUrl, requestBody: request, headers: header);

  static dynamic callWithdrawalRequestApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.cashierBaseUrl, MethodType.post, ApiUrlsConstant.withdrawalRequestUrl, requestBody: request, headers: header);

  static dynamic callConvertToPgCurrencyApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.cashierBaseUrl, MethodType.post, ApiUrlsConstant.convertToPgCurrencyUrl, requestBody: request, headers: header);

}