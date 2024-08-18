import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class ReferAFriendRepository {

  static dynamic callTrackStatusApi(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.trackStatus,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );

  static dynamic callInviteFriendApi(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.weaverBaseUrl,
        MethodType.post,
        ApiUrlsConstant.inviteFriend,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );
}
