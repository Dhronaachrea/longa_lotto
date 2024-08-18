import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/api_urls_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/alert/alert_dialog.dart';
import 'package:longa_lotto/common/widget/longa_app_bar.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class DepositWebView extends StatefulWidget {
  final String? amount;
  final String? currencyCode;
  final String? paymentTypeId;
  final String? subTypeId;
  final String? mobileNumber;
  DepositWebView({Key? key, required this.amount, required this.currencyCode, required this.paymentTypeId, required this.subTypeId, required this.mobileNumber}) : super(key: key);

  @override
  State<DepositWebView> createState() => _DepositWebViewState();
}

class _DepositWebViewState extends State<DepositWebView> {
  late WebViewController _controller;
  late String url;
  String paymentTypeId = '';
  double progress = 0;
  var decoded;
  bool isWebViewLoaded = false;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        useShouldInterceptFetchRequest: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));


  String getHtmlStringValue() {
    String countryCode = (widget.subTypeId == "7" && widget.paymentTypeId == "3") ? "243" : "";
    // String


    String fileHtmlContents = '''
<html>
  <head>
      <link rel="stylesheet" type="text/css" href="styles.css" class="centerTxt">
  </head>
  <div class="center">
      <div class="loader"></div>
  </div>
  <body onload='document.forms["payment_form"].submit()'>
  <h2>${context.l10n.please_wait_it_might_take_a_few_sec}<br>
  ${context.l10n.please_do_not_refresh_the_page_or_click}</h2>
  <form action='${baseUrlMap[BaseUrlEnum.cashierBaseUrl]}/player/payment/depositRequest' method='post' name='payment_form' id='form-submit'>
  <input type='hidden' name='amount' value=${widget.amount ?? 0} />
  <input type='hidden' name='currencyCode' value='${widget.currencyCode ?? "CDF"}' />
  <input type='hidden' name='pgCurrencyCode' value='${widget.currencyCode ?? "CDF"}' />
  <input type='hidden' name='deviceType' value='MOBILE' />
  <input type='hidden' name='domainName' value=${AppConstants.domainName} />
  <input type='hidden' name='merchantCode' value=${AppConstants.merchantCode} />
  <input type='hidden' name='paymentTypeId' value=${widget.paymentTypeId ?? "-"} />
  <input type='hidden' name='playerId' value=${UserInfo.userId} />
  <input type='hidden' name='playerToken' value=${UserInfo.userToken} />
  <input type='hidden' name='txnType' value='DEPOSIT' />
  <input type='hidden' name='subTypeId' value=${widget.subTypeId ?? "-"} />
  <input type='hidden' name='depositInputs.payer_address' value=$countryCode${widget.mobileNumber ?? "-"} />
  <input type='hidden' name='respSuccess' value='https://www.longagames.com/fr/my-wallet' />
  <input type='hidden' name='respError' value='https://www.longagames.com/en/my-wallet' />
  <input type='hidden' name='MerchantId' value='6bcc3cfcc6a947cb81a37b28274bf61e' />
  <input type='hidden' name='MerchantPassword' value='b67cc557861445a69494602fe62996b8' />
  </form>
  </body>
</html>
''';
    return fileHtmlContents;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
        /*if (isWebViewLoaded) {
          var response = await ConfirmDialog.show(
            context: context,
            message: 'Are you sure you want to go back?',
            negativeButtonText: 'Stay',
            positiveButtonText: 'Back',
          );
          return response ?  true : false;
        }*/
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: LongaAppBar(
              backgroundColor: LongaColor.marigold,
              title: context.l10n.deposit,
              showBalance: false,
              showBell: true,
              isDepositWebView: true
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 1),
              child:InAppWebView(
                initialData: InAppWebViewInitialData(data: getHtmlStringValue()),

                initialOptions: options,
                onWebViewCreated: (InAppWebViewController webViewController) {
                  print("InAppWebViewController ===");
                  // loadHtmlFile();
                },
                onLoadStart: (controller, uri) {
                  controller.getHitTestResult().then((value) => {
                    print("result value= ====> ${value}")
                  });

                  controller.getOriginalUrl().then((value) => {
                    print("orignal url ------------> ${value}")

                  });

                  log("Loading Start 1====> ${uri}");
                  print("Loading Start 2====> ${uri?.data}");
                },
                /*onLoadStop: (InAppWebViewController controller, Uri? url) async{

                  final response = await controller.getHitTestResult();
                  log('Response Data: ${response}');

                },*/
                onLoadError: (controller, uri, i, j) {
                  log("============>onLoadError");
                  Navigator.pop(context);
                  ShowToast.showToast(context, context.l10n.deposit_failed, type: ToastType.ERROR);
                },
                onLoadHttpError: (controller, uri, i, j) {
                    log("============>onLoadHttpError");
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  print(
                      "shouldOverrideUrlLoading ================= > ${uri.toString()}");

                  http.Response response = await http.get(uri);
                  try {
                    if (response.statusCode == 200) {
                      String data = response.body;
                      var decodedData = jsonDecode(data);
                      return decodedData;
                    } else {
                    }
                  } catch (e) {
                  }

                  if (![ "http", "https", "file", "chrome",
                    "data", "javascript", "about"].contains(uri.scheme)) {
                    if (await canLaunch(url)) {
                      // Launch the App
                      await launch(
                        url,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;

                },
                onLoadStop: (controller, url) async {

                  /*await controller.evaluateJavascript(source: 'document.getElementsByName("responseJson")').then((value) => {
                    log("api oooooooooooooooo ==> $value")
                  });*/
                  controller.getHtml().then((html) {
                    log('API Response HTML: $html');
                    var document = parse(html);
                    var inputElement = document.querySelector('input[name="responseJson"]');
                    if (inputElement != null) {
                      // Extract the value attribute of the input element

                      final responseJson = inputElement.attributes['value'];
                       log("response 2 ==========> $responseJson");

                      if (responseJson != null) {
                        print("responseJson 22================= > ${responseJson}");

                        var decode  = jsonDecode(responseJson.toString());
                        print("status ================= > ${decode["status"]}");
                        if (decode["status"] == "FAILED" || decode["status"] == null){
                          if (UserInfo.isLoggedIn()) {
                            fetchHeaderInfo(navigatorKey.currentContext ?? context);
                          }
                          Navigator.pop(context);
                          // ShowToast.showToast(context, decode["respMsg"], type: ToastType.ERROR);
                          ShowToast.showToast(context, context.l10n.deposit_failed, type: ToastType.ERROR);
                        } else if(decode["status"] == "PENDING") {
                          if (UserInfo.isLoggedIn()) {
                            fetchHeaderInfo(navigatorKey.currentContext ?? context);
                          }
                          Navigator.pop(context, decode['txnId']);
                          //ShowToast.showToast(context, context.l10n.deposit_initiated, type: ToastType.SUCCESS);
                        }
                        else {
                          print("responseJson ================= > ${responseJson}");
                          if (UserInfo.isLoggedIn()) {
                            fetchHeaderInfo(navigatorKey.currentContext ?? context);
                          }
                          Navigator.pop(context);
                          // ShowToast.showToast(context, decode["respMsg"], type: ToastType.SUCCESS);
                          ShowToast.showToast(context, context.l10n.deposit_successful, type: ToastType.SUCCESS);
                        }
                      } else {
                        print("===========> getting null value from deposit webview <==================");

                        Navigator.pop(context);
                        ShowToast.showToast(context, context.l10n.something_went_wrong, type: ToastType.ERROR);
                      }
                    }
                  });

                  await controller.callAsyncJavaScript(functionBody: "document.getElementsByName('responseJson')").then((value) => {
                    log("getting response ==================> ${value}")

                  });
                  /*controller.addJavaScriptHandler(
                      handlerName: "document.getElementsByName('responseJson')",
                      callback: (args) {
                        log('args===$args');
                      });*/

                },
                onProgressChanged: (controller, i) {
                  if(this.mounted) {
                    setState(() {
                      this.progress = i / 100;
                    });
                  }
                },
              )
              ,
            ),
            progress < 1.0
                ? LinearProgressIndicator(
              value: progress,
              backgroundColor: LongaColor.marigold.withOpacity(0.3),
              color: LongaColor.marigold,
            )
                : Container(),
          ],
        ),
      ),
    );
  }


  bool checkIsWebViewLoaded(isWebViewLoaded) {
    if (isWebViewLoaded) {
      return true;
    }
    return false;
  }

  void loadHtmlFile() {
    final url = Uri.dataFromString(
      getHtmlStringValue(),
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
    log("[Deposit Request]: " + getHtmlStringValue());
    // _controller.loadHtmlString(getHtmlStringValue());

    // _controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)), );
    _controller.loadUrl(url);
  }

  _onPageFinished() {
    _controller.runJavascriptReturningResult(
      "document.getElementsByName('responseJson')[0].value",
    ).then(
          (responseJson) {

        /*{
            "txnId": "10271",
            "netAmount": 4812.0,
            "status": "FAILED",
            "txnType": "DEPOSIT",
            "responseUrl": "https%3A%2F%2Fuat.longagames.com%2Fen%2Fmy-wallet",
            "firstDeposit": false,
            "txnDate": "2023-06-29 07:14:41",
            "domainName": "www.longagames.com",
            "userName": "Coffee123",
            "errorCode": 0,
            "respMsg": "Deposit Transaction Failed",
            "errorMsg": "DEPOSITRequest Failed..."
          }*/

            /*{
              "txnId": "10957",
            "netAmount": 80.0,
            "status": "PENDING",
            "txnType": "DEPOSIT",
            "responseUrl": "https%3A%2F%2Fuat.longagames.com%2Fen%2Fmy-wallet",
            "firstDeposit": false,
            "view": "cashier",
            "domainName": "www.longagames.com",
            "userName": "Coffee123",
            "errorCode": 0,
            "respMsg": "Deposit request initiated successfully, check mobile phone to confirm transaction without leaving the page you are on."
          }*/

          print("responseJson ================= > ${responseJson}");

        if (responseJson != 'null') {
          print("responseJson ================= > ${responseJson}");
          var decode  = jsonDecode(jsonDecode(responseJson));
          print("status ================= > ${decode["status"]}");
          if (decode["status"] == "FAILED" || decode["status"] == null){
            if (UserInfo.isLoggedIn()) {
              fetchHeaderInfo(navigatorKey.currentContext ?? context);
            }
            Navigator.pop(context);
            // ShowToast.showToast(context, decode["respMsg"], type: ToastType.ERROR);
            ShowToast.showToast(context, context.l10n.deposit_failed, type: ToastType.ERROR);
          } else if(decode["status"] == "PENDING") {
            if (UserInfo.isLoggedIn()) {
              fetchHeaderInfo(navigatorKey.currentContext ?? context);
            }
            Navigator.pop(context, decode['txnId']);
            //ShowToast.showToast(context, context.l10n.deposit_initiated, type: ToastType.SUCCESS);
          }
          else {
            print("responseJson ================= > ${responseJson}");
            if (UserInfo.isLoggedIn()) {
              fetchHeaderInfo(navigatorKey.currentContext ?? context);
            }
            Navigator.pop(context);
            // ShowToast.showToast(context, decode["respMsg"], type: ToastType.SUCCESS);
            ShowToast.showToast(context, context.l10n.deposit_successful, type: ToastType.SUCCESS);
          }
        } else {
          print("===========> getting null value from deposit webview <==================");

          // Navigator.pop(context);
          // ShowToast.showToast(context, context.l10n.something_went_wrong, type: ToastType.ERROR);
        }

      },
    )
        .catchError((error) => null)
        .onError((error, stackTrace) {
          print("error  ================== > ${error}");
          print("error  stackTrace ================== > ${stackTrace}");
    });
  }

}
