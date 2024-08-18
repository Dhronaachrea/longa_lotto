import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class SplashRepository {

  static dynamic callVersionControlApi(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.versionControlUrl,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );
}
