import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/main.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResultWebView extends StatefulWidget {

  const ResultWebView({
    Key? key,
  }) : super(key: key);

  @override
  _ResultWebViewState createState() => _ResultWebViewState();
}

class _ResultWebViewState extends State<ResultWebView> {
  late WebViewController _controller;
  double progress = 0;
  String finalUrlString = '';
  String url = '';
  String gameUrl = LongaConstant.gameUrl;
  String gameType = LongaConstant.dgeGameType;
  String gameCode = '';

  @override
  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllPrefs();
    });*/
  }
 //https://uat-games.longagames.com/dge/results/3047/Coffee123/Y1ehHuLFfMnWV7VXgsQKRswbd6XZGEo7QoEDLPg_6Pw/99999999500.00/en/CDF/CDF/www.longagames.com/1
  _getAllPrefs(BuildContext context) {
    String totalBalance = UserInfo.totalBalance.toString();

    gameUrl = LongaConstant.gameUrl;
    gameType = LongaConstant.dgeGameType;

    url = gameUrl +
        gameType +
        "/" +
        "results" +
        "/" +
        ( UserInfo.isLoggedIn()
            ? (UserInfo.userId == '' ? '-' : UserInfo.userId)
            : '-') +
        "/" +
        (UserInfo.isLoggedIn()
            ? (UserInfo.userName == '' ? '-' : UserInfo.userName)
            : '-') +
        "/" +
        (UserInfo.isLoggedIn()
            ? (UserInfo.userToken == "" ? "-" : UserInfo.userToken)
            : '-') +
        "/" +
        totalBalance //TotalBalance
        +
        "/" +
        LongaLottoApp.of(context).getLocale().toString().split("_")[0] +
        "/" +
        LongaConstant.currencyCode +
        "/" +
        LongaConstant.currencyDisplayCode +
        "/" +
        LongaConstant.domainName +
        "/" +
        LongaConstant.mobilePlatform;
    log("dge game resultURL: : $url");

    finalUrlString = url;

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _getAllPrefs(context);
    final scaffoldBody = WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Stack(
          children: [
            finalUrlString != ''
                ? WebView(
                    initialUrl: finalUrlString,
                    zoomEnabled: false,
                    navigationDelegate: (action) {
                      return NavigationDecision.navigate;
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: {
                      JavascriptChannel(
                          name: 'goToHome',
                          onMessageReceived: (JavascriptMessage response) {
                            log("goToHome response : ${response.message}");
                            Navigator.pop(context);
                          }),
                      JavascriptChannel(
                        name: 'loadInstantGameUrl',
                        onMessageReceived: (JavascriptMessage responseUrl) {
                          log("loadInstantGameUrl responseUrl : ${responseUrl.message}");
                        },
                      ),
                      JavascriptChannel(
                        name: 'showLoginDialog',
                        onMessageReceived: (JavascriptMessage response) {
                          log("showLoginDialog response : ${response.message}");
                        },
                      ),
                      JavascriptChannel(
                        name: 'onBalanceUpdate',
                        onMessageReceived: (JavascriptMessage response) {
                          log("onBalanceUpdate response : ${response.message}");
                        },
                      ),
                      JavascriptChannel(
                        name: 'loginWindow',
                        onMessageReceived: (JavascriptMessage response) {
                          log("loginWindow response : ${response.message}");
                        },
                      ),
                      JavascriptChannel(
                        name: 'backToLobby',
                        onMessageReceived: (JavascriptMessage response) {
                          log("backToLobby response : ${response.message}");
                          Navigator.pop(context);
                        },
                      ),
                      JavascriptChannel(
                        name: 'reloadGame',
                        onMessageReceived: (JavascriptMessage response) {
                          log("reloadGame response : ${response.message}");
                        },
                      ),
                      JavascriptChannel(
                        name: 'updateBal', //working
                        onMessageReceived: (JavascriptMessage response) {
                          log("updateBal response ");
                        },
                      ),
                      JavascriptChannel(
                        name: 'getWindowDimensions',
                        onMessageReceived: (JavascriptMessage response) {
                          log("getWindowDimensions response : ${response.message}");
                        },
                      ),
                    },
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _controller.loadUrl(Uri.parse(finalUrlString).toString());
                      log(finalUrlString);
                    },
                    onPageFinished: (url) {},
                    debuggingEnabled: true,
                    onProgress: (progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  )
                : Container(),
            progress < 1.0
                ? LinearProgressIndicator(
                    value: progress,
                    backgroundColor: LongaColor.darkish_purple_two,
                  )
                : Container(),
          ],
        ),
      ),
    );
    return LongaScaffold(
            showAppBar: false,
            body: scaffoldBody,
          );
  }
}
