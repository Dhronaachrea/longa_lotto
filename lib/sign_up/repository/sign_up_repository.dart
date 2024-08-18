import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class SignUpRepository {
  static dynamic callCheckAvailabilityApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.checkAvailabilityUrl, requestBody: request);

  static dynamic callSendRegOtpApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.get, ApiUrlsConstant.sendRegOtpUrl, params: request, headers: header);

  static dynamic callRegistrationApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.registrationUrl, requestBody: request, headers: header);

  static dynamic callRegistrationWithScannerApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.registerPlayerWithScannerUrl, requestBody: request, headers: header);

}