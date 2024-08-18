import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';

enum ButtonShrinkStatus{notStarted, started, over}

enum ProfilePhotoSelectOptions{camera, gallery, view}

class LongaConstant {
  static const double accountGridBorderWidth    = 0.5;
  static const double bottomNavigationHeight    = 70;
  static const double bottomNavigationIconSize  = 20;
  static const double bottomNavigationTextSize  = 20;
  static const String inboxLimit  = "30";
  static const String inboxOffset = "0";

  static const LinearGradient LongaGradientColor = LinearGradient(
    begin: Alignment(1, 0),
    end: Alignment(0, 1),
    colors: [
      LongaColor.marigold,
      LongaColor.tangerine,
    ],
  );

  static String gameUrl                   = "${baseUrlMap[BaseUrlEnum.webViewGameUrl]}/";
  static const String dgeGameType         = "dge";
  static const String igeGameType         = "ige";
  static const String language            = "en";
  static const String currencyCode        = 'CDF';
  static const String currencyDisplayCode = "CDF";
  static const String domainName          = "www.longagames.com";
  static const String mobilePlatform      = "1";
}
