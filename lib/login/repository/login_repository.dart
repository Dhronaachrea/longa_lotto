import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class LoginRepository {

  static dynamic callLoginApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.ramBaseUrl, MethodType.post, ApiUrlsConstant.loginUrl, requestBody: request, headers: header);

}