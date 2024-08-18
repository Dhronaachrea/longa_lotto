import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class DashBoardRepository {
  static dynamic callCheckBonusStatusPLayerApi(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> header) async =>
      await CallApi.callApi(BaseUrlEnum.bonusBaseUrl, MethodType.post, ApiUrlsConstant.checkBonusStatusUrl, requestBody: request, headers: header);

}