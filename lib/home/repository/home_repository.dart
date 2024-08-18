import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/network/api_call.dart';

class HomeRepository {
  static dynamic callFetchDgeGame(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.dgeBaseUrl,
        MethodType.put,
        ApiUrlsConstant.FETCH_DGE_GAME_URL,
        requestBody: request,
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "password": "password",
          "username": "weaver",
        },
      );

  static dynamic callFetchIgeGame(
          BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        BaseUrlEnum.igeBaseUrl,
        MethodType.post,
        ApiUrlsConstant.FETCH_IGE_GAME_URL,
        requestBody: request,
      );
}
