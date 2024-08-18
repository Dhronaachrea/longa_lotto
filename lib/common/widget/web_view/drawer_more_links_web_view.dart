import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/main.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constant/api_urls_constant.dart';

class DrawerMoreLinksWebView extends StatefulWidget {
  final List<String?>? screenDetail;

  const DrawerMoreLinksWebView({
    Key? key,
    this.screenDetail,
  }) : super(key: key);

  @override
  _DrawerMoreLinksWebViewState createState() => _DrawerMoreLinksWebViewState();
}

class _DrawerMoreLinksWebViewState extends State<DrawerMoreLinksWebView> {
  late WebViewController _controller;
  double progress = 0;
  String url = '';
  String title = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllPrefs();
    });

    super.initState();
  }

  _getAllPrefs() {
    setState(() {
      //String totalBalance = context.read<AuthBloc>().cashBalance ?? "0";
      switch(widget.screenDetail?[0]){
        case "t&c":
          print("------------------------>${widget.screenDetail?[0]}");
          title = context.l10n.termsAndConditions;
          url ="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/${LongaLottoApp.of(context).getLocale().toString().split("_")[0]}/mobile-terms-conditions";
          break;
        case "privacyPolicy":
          title = context.l10n.privacyPolicy;
          url ="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/${LongaLottoApp.of(context).getLocale().toString().split("_")[0]}/mobile-privacy-policy";
          break;
        case "igeKnowMore":
          print("------------------------>${widget.screenDetail?[0]}");
          print("-----gamename------------------->${widget.screenDetail?[1]}");

          //cash-&-gold-10x
          var gameName =  widget.screenDetail?[1]?.toLowerCase().replaceAll(" ", "-");
          if (gameName == "cash-&-gold-10x") {
            gameName = "cash-gold";
          }
          title = "Instant Info";
          //https://uat.longagames.com/en/how-to-play-node-20x-bonanza
          url = "${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/${LongaLottoApp.of(context).getLocale().toString().split("_")[0]}/how-to-play-node-$gameName";
      }
      print("url=================>$url");
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = SafeArea(
      child: Stack(
        children: [
          url != ''
              ? Container(
            width: double.infinity,
            height: double.infinity,
            color: LongaColor.white,
            child: WebView(
              navigationDelegate: (action) {
                return NavigationDecision.navigate;
              },
              javascriptMode: JavascriptMode.unrestricted,
              zoomEnabled: false,
              javascriptChannels: {
                JavascriptChannel(
                  name: 'goToHome',
                  onMessageReceived: (JavascriptMessage response) {
                    log("goToHome response : ${response.message}");
                    Navigator.pop(context);
                    if (UserInfo.isLoggedIn()) {
                      isInternetConnect().then((value) {
                        if(value) {
                          fetchHeaderInfo(navigatorKey.currentContext ?? context);
                        } else {
                          ShowToast.showToast(context, context.l10n.no_internet_available, type: ToastType.INFO);
                        }
                      });
                    }
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
                    isInternetConnect().then((value) {
                      if(value) {
                        fetchHeaderInfo(navigatorKey.currentContext ?? context);
                      } else {
                        ShowToast.showToast(context, context.l10n.no_internet_available, type: ToastType.INFO);
                      }
                    });
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
                  },
                ),
                JavascriptChannel(
                  name: 'reloadGame',
                  onMessageReceived: (JavascriptMessage response) {
                    log("reloadGame response1 : ${response.message}");
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
                isInternetConnect().then((value) {
                  if(value) {
                    _controller.loadUrl(url);
                    if (UserInfo.isLoggedIn() ) {
                      fetchHeaderInfo(navigatorKey.currentContext ?? context);
                    }
                  } else {
                    ShowToast.showToast(context,  context.l10n.no_internet_available, type: ToastType.INFO);
                  }
                });


              },
              onPageFinished: (url) {
                print("===============>$url");
              },
              debuggingEnabled: false,
              onProgress: (progress) {

                setState(() {
                  this.progress = progress / 100;
                });
              },
            ).p(13),
          )
              : Container(
            color: Colors.white,
          ),
          progress < 1.0
              ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Lottie.asset('assets/lottie/gradient_loading.json')),
            ),
          )
              : Container(),
        ],
      ),
    );
    return widget.screenDetail == null
        ? LongaScaffold(
            showAppBar: true,
            appBarTitle: title.toUpperCase(),
            body: scaffoldBody,
          )
        : LongaScaffold(
            showAppBar: true,
            appBarTitle: title.toUpperCase(),
            body: scaffoldBody,
          );
  }

  _onLoginCallBack() {
    _getAllPrefs();
    if (widget.screenDetail == null) Navigator.pop(context);
    _controller.loadUrl(url);
  }
}
