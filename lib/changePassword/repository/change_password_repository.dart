import 'package:flutter/widgets.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class ChangePasswordRepository {

  static dynamic callChangePasswordApi(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.changePasswordUrl, requestBody: request);

}