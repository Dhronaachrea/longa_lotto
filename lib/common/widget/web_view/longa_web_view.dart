import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/main.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../alert/alert_dialog.dart';

class LongaWebView extends StatefulWidget {
  final GameRespVo? dgeGame;
  final Games? igeGame;
  final LONGALOTTO? igeResponse;

  const LongaWebView({
    Key? key,
    this.dgeGame,
    this.igeGame,
    this.igeResponse,
  }) : super(key: key);

  @override
  _LongaWebViewState createState() => _LongaWebViewState();
}

class _LongaWebViewState extends State<LongaWebView> {
  late WebViewController _controller;
  double progress = 0;
  String finalUrlString = '';
  String url = '';
  String gameUrl = LongaConstant.gameUrl;
  String gameType = LongaConstant.dgeGameType;
  String gameCode = '';

  /*InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        useShouldInterceptFetchRequest: true,
        javaScriptEnabled: true,
        userAgent: AppConstants.userAgent

      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late InAppWebViewController webController;*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllPrefs();
    });
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  _getAllPrefs() {
    String totalBalance = context.read<AuthBloc>().cashBalance ?? "0";
    // var jsonMap = jsonDecode(AppData.versionResponse);
    // VersionResponse versionResponse = VersionResponse.fromJson(jsonMap);
    if (widget.dgeGame != null) {
      gameUrl = LongaConstant.gameUrl;
      gameType = LongaConstant.dgeGameType;
      gameCode = (widget.dgeGame?.gameCode ?? "").toLowerCase();
      log("gameUrl: $gameUrl");
      url = gameUrl +
          gameType +
          "/" +
          gameCode +
          "/" +
          (UserInfo.userId == ''
              ? '-'
              : UserInfo.isLoggedIn()
                  ? UserInfo.userId
                  : '-') +
          "/" +
          (UserInfo.userName == ''
              ? '-'
              : UserInfo.isLoggedIn()
                  ? UserInfo.userName
                  : '-') +
          "/" +
          (UserInfo.userToken == ''
              ? '-'
              : UserInfo.isLoggedIn()
                  ? UserInfo.userToken
                  : '-') +
          "/" +
          totalBalance //TotalBalance
          +
          "/" +
          LongaLottoApp.of(context).locale.languageCode
          +
          "/" +
          LongaConstant.currencyCode +
          "/" +
          LongaConstant.currencyDisplayCode +
          "/" +
          LongaConstant.domainName +
          "/" +
          LongaConstant.mobilePlatform;
      log("dge gameURL: : $url");
    } else {
      gameUrl = LongaConstant.gameUrl;
      gameType = LongaConstant.igeGameType;
      gameCode = (widget.igeGame?.gameNumber ?? "").toString() + "/buy";
      url = '${widget.igeResponse?.params?.repo}?' +
          'root=${widget.igeResponse?.params?.root}' +
          '&gameNum=${widget.igeGame?.gameNumber}' +
          '&gameMode=buy' +
          '&domainName=${AppConstants.domainName}' +
          '&merchantKey=${widget.igeResponse?.params?.merchantKey}' +
          '&secureKey=${widget.igeResponse?.params?.secureKey}' +
          '&currencyCode=${UserInfo.currencyDisplayCode}' +
          '&lang=${LongaLottoApp.of(context).locale.languageCode == 'fr' ? "fr": widget.igeResponse?.params?.lang}' +
          '&gameType=scratch' +
          '&playerId=${UserInfo.userId}' +
          '&merchantSessionId=${UserInfo.userToken}' +
          '&balance=${UserInfo.totalBalance}' +
          '&commCharge=0' +
          '&userAgentIge=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36' +
          '&deviceType=MOBILE_WEB' +
          '&appType=WEB' +
          '&clientType=FLASH' +
          '&ticketPrice=' +
          '&launchIc=${widget.igeGame?.imagePath}' +
          '&prizeSchemeIge=${json.encode(widget.igeGame?.prizeSchemes)}' +
          '&loaderImage=${json.encode(widget.igeGame?.loaderImage)}' +
          '&currencyDisplay=${UserInfo.currencyDisplayCode}' +
          '&merchantCode=${widget.igeResponse?.params?.merchantCode}' +
          '&name=${widget.igeResponse?.params?.domainName}' +
          '&deviceCheck=false' +
          '&priceSchemes=${json.encode(widget.igeGame?.prizeSchemes)}' +
          '&prizeSchemeId={widget.igeGame?.prizeSchemes?.d441' +
          '&bonusMultiplier=${widget.igeGame?.bonusMultiplier}' +
          '&productInfo=${json.encode(widget.igeGame?.productInfo?.toJson())}' +
          // '&isNative=${Platform.isAndroid ? 'android' : 'ios'}';
          '&isNative=android';
      log("ige gameURL: : $url");
    }

    finalUrlString = url;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = WillPopScope(
      onWillPop: () async {
        Alert.show(
          isDarkThemeOn: false,
          buttonClick: () {
            fetchHeaderInfo(navigatorKey.currentContext ?? context);
            Navigator.pop(context);
          },
          title: context.l10n.exit,
          isCloseButton: true,
          subtitle: context.l10n.are_you_sure_you_want_to_exit,
          buttonText: context.l10n.ok.toUpperCase(),
          context: context,
        );
        return false;
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
                    userAgent: AppConstants.userAgent,
                    initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                    javascriptChannels: {
                            JavascriptChannel(
                                name: 'goToHome',
                                onMessageReceived: (JavascriptMessage response) {
                                  log("goToHome response : ${response.message}");
                                  Navigator.pop(context);
                                  if (UserInfo.isLoggedIn()) {
                                    fetchHeaderInfo(
                                        navigatorKey.currentContext ?? context);
                                  }
                                }),
                            JavascriptChannel(
                              name: 'loadInstantGameUrl',
                              onMessageReceived: (JavascriptMessage responseUrl) {
                                log("loadInstantGameUrl responseUrl : ${responseUrl.message}");
                                // finalUrlString =
                                //     '${responseUrl.message}&isNative=android';
                                // _controller.loadUrl(finalUrlString);
                              },
                            ),
                            JavascriptChannel(
                              name: 'showLoginDialog',
                              onMessageReceived: (JavascriptMessage response) {
                                log("showLoginDialog response : ${response.message}");
                                showDialog(
                                  context: context,
                                  builder: (context) => BlocProvider<LoginBloc>(
                                    create: (context) => LoginBloc(),
                                    child: LoginScreen(
                                      onLoginNavCallback: _onLoginCallBack,
                                    ),
                                  ),
                                );
                              },
                            ),
                            JavascriptChannel(
                              name: 'onBalanceUpdate',
                              onMessageReceived: (JavascriptMessage response) {
                                log("onBalanceUpdate response : ${response.message}");
                                if (UserInfo.isLoggedIn()) {
                                  fetchHeaderInfo(
                                      navigatorKey.currentContext ?? context);
                                }
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
                                if (UserInfo.isLoggedIn()) {
                                  fetchHeaderInfo(
                                      navigatorKey.currentContext ?? context);
                                }
                              },
                            ),
                            JavascriptChannel(
                              name: 'getWindowDimensions',
                              onMessageReceived: (JavascriptMessage response) {
                                log("getWindowDimensions response : ${response.message}");
                              },
                            ),
                            JavascriptChannel(
                              name: 'Unfinished',
                              onMessageReceived: (JavascriptMessage response) {
                                log("Unfinished response : ${response.message}");
                              },
                            ),
                            JavascriptChannel(
                              name: 'Finished',
                              onMessageReceived: (JavascriptMessage response) {
                                log("Finished response : ${response.message}");
                              },
                            ),
                          },
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _controller.loadUrl(Uri.parse(finalUrlString).toString());
                      log(finalUrlString);
                    },
                    onPageFinished: (url)  {},
                    debuggingEnabled: false,
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
    return widget.dgeGame == null
        ? LongaScaffold(
            showAppBar: true,
            appBarTitle: widget.igeGame?.gameName!.toUpperCase(),
            isIgeGames: (widget.dgeGame != null ) ? false : true,
            body: scaffoldBody,

          )
        : LongaScaffold(
            showAppBar: false,
            body: scaffoldBody,
          );
  }

  _onLoginCallBack() {
    _getAllPrefs();
    if (widget.dgeGame == null) Navigator.pop(context);
    _controller.loadUrl(finalUrlString);
  }

  void _onConfirmExit(BuildContext mCtx) {
    fetchHeaderInfo(navigatorKey.currentContext ?? context);
    Navigator.pop(context);
  }
}
