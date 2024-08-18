import 'package:flutter/material.dart';
import 'package:longa_lotto/common/widget/drawer/drawer_widgets/drawer_web_view.dart';
import 'package:longa_lotto/main.dart';
import 'package:longa_lotto/utils/user_info.dart';

import '../common/constant/longa_constant.dart';

class TicketWebViewScreen extends StatefulWidget {
  final Map<String, dynamic> ticketDetail;

  const TicketWebViewScreen({Key? key, required this.ticketDetail})
      : super(key: key);

  @override
  State<TicketWebViewScreen> createState() => _TicketWebViewScreenState();
}

class _TicketWebViewScreenState extends State<TicketWebViewScreen> {
  String gameUrl = LongaConstant.gameUrl;

  @override
  Widget build(BuildContext context) {
    String gameType = widget.ticketDetail["gameType"];
    String transactionId = widget.ticketDetail["transactionId"];
    String selectedLanguage = LongaLottoApp.of(context).getLocale().toString().split("_")[0];
    String url;

    switch (gameType) {
      case "dge":
      //https://games-wls.infinitilotto.com/dge/results/1734/747474573/rynK2V0Aqr9h0Bm1hOSyb0iGpmeOULiHEoJvuTTrsPM/0.00/en/EUR/EUR/ice.igamew.com/1
        url = "$gameUrl/dge/view-ticket/0/$transactionId/${UserInfo.userId == '' ? '-' : UserInfo.userId}/${UserInfo.isLoggedIn() ? UserInfo.userName == '' ? UserInfo.mobNumber : UserInfo.userName : "-"}/${UserInfo.userToken == '' ? '-' : UserInfo.userToken}/${UserInfo.cashBalance.toString().isNotEmpty ? UserInfo.cashBalance : "-"}/$selectedLanguage/${(UserInfo.currencyDisplayCode.isNotEmpty ? UserInfo.currencyDisplayCode : "")}/${(UserInfo.currencyDisplayCode.isNotEmpty ? UserInfo.currencyDisplayCode : "")}/${LongaConstant.domainName}/1";
        break;

      default:
        url = "$gameUrl/$gameType/view-ticket/0/$transactionId/${UserInfo.userId == '' ? '-' : UserInfo.userId}/${UserInfo.userName == '' ? '-' : UserInfo.userName}/${UserInfo.userToken == '' ? '-' : UserInfo.userToken}/${UserInfo.cashBalance.toString().isNotEmpty ? UserInfo.cashBalance : "-"}/$selectedLanguage/${(UserInfo.currencyDisplayCode.isNotEmpty ? UserInfo.currencyDisplayCode : "EUR")}/${(UserInfo.currencyDisplayCode.isNotEmpty ? UserInfo.currencyDisplayCode : "EUR")}/${LongaConstant.domainName}/1";
    }

    return DrawerWebView(
      url: url,
    );
  }
}
