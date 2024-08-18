import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DrawerWebView extends StatefulWidget {
  final String url;
  final bool showAppBar;

  const DrawerWebView({
    Key? key,
    required this.url,
    this.showAppBar = false,
  }) : super(key: key);

  @override
  _DrawerWebViewState createState() => _DrawerWebViewState();
}

class _DrawerWebViewState extends State<DrawerWebView> {
  late WebViewController _controller;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    final scaffoldBody = WillPopScope(
      onWillPop: () async {
        fetchHeaderInfo(navigatorKey.currentContext ?? context);
        return true;
      },
      child: SafeArea(
        child: Stack(
          children: [
            widget.url != ''
                ? WebView(
                    initialUrl: widget.url,
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
                    },
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller = webViewController;
                      _controller.loadUrl(Uri.parse(widget.url).toString());
                      log(widget.url);
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

    return widget.showAppBar
        ? LongaScaffold(
            showAppBar: false,
            body: scaffoldBody,
          )
        : Container(
            child: scaffoldBody,
          );
  }

  _onLoginCallBack() {
    _controller.loadUrl(widget.url);
  }
}
