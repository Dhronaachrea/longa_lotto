import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkHandler {
  static StreamSubscription? _sub;

  static Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      handleLink(initialLink);

      _sub = linkStream.listen((String? link) {
        handleLink(link);
      });
    } on PlatformException {
      // Handle exception
    }
  }

  static void handleLink(String? link) {

    if (link != null && link.startsWith('https://')) {
      // https://uat.longagames.com/en/component/weaver/?task=ram.addCoupans&
      // couponCode=132d17e7-d073-491b-8805-2fe1deda1223&
      // currencyCode=CDF&
      // countryCode=CD
      try {
        var responseDataMap = {};
        List<String> dataList = link.split("&");
        dataList.removeAt(0);

        for(var data in dataList) {
          var splitData = data.split("=");
          responseDataMap[splitData[0]] = splitData[1];
        }
        print(responseDataMap);

        try {
          print("scan value -----> $link");

          Map<String, String> proceedData = {};
          /*Uri uri = Uri.dataFromString(link.toString());
          proceedData["couponCode"]     = uri.queryParameters['couponCode']!;
          proceedData["currencyCode"]   = uri.queryParameters['currencyCode']!;
          proceedData["countryCode"]    = uri.queryParameters['countryCode']!;*/
          Uri uri = Uri.dataFromString(link.toString());
          proceedData["t"] = uri.queryParameters['t']!;
          proceedData["t"] = uri.queryParameters['t']!;
          proceedData["t"] = uri.queryParameters['t']!;

          print("Final deep link data==============>$proceedData");

          UserInfo.setDeepLinkData(jsonEncode(proceedData));
        } catch (e) {

          print("Something Went wrong with bar code: $e");
        }


      } catch (e) {
        print("Deeplink Error Occured : $e");
      }

    }
  }

  static void dispose() {
    _sub?.cancel();
  }
}
