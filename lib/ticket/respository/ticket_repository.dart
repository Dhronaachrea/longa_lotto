import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class TicketRepository {

  static dynamic getTicketList(BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(BaseUrlEnum.weaverBaseUrl, MethodType.post, ApiUrlsConstant.getTicketListUrl, requestBody: request);
}