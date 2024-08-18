import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class UtilsRepository {
  static dynamic getBalanceApi(
      BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.getBalanceUrl,
        requestBody: request,
      );

  static dynamic logOutApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.logoutUrl, requestBody: request,);
}
