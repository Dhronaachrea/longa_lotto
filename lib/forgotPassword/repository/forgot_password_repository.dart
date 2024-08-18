import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class ForgotPasswordRepository {
  static dynamic callForgotPasswordApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.forgotPasswordUrl, requestBody: request, headers: header);

  static dynamic callResetPasswordApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.resetPasswordUrl, requestBody: request);

}