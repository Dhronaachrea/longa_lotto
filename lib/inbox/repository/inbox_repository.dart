import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class InboxRepository {
  static dynamic callInbox(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.Inbox_URL,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );

  static dynamic callInboxActivity(
      BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.INBOX_ACTIVITY_URL,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );
}
