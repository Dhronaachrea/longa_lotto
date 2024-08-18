import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_bloc.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_event.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_state.dart';
import 'package:longa_lotto/utils/scanner_error.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:velocity_x/velocity_x.dart';

class ScanLoginScreen extends StatefulWidget {
  final VoidCallback onTap;
  const ScanLoginScreen({required this.onTap});


  @override
  State<ScanLoginScreen> createState() => _ScanLoginScreenState();
}

class _ScanLoginScreenState extends State<ScanLoginScreen> {

  final MobileScannerController _scanController = MobileScannerController(autoStart: true);

  bool flashOn = false;

  bool _pendingWithdrawalLoader = false;
  bool _isApproved = false;
  String mRequestId = "";
  String mDomainId = "";
  String mAliasId = "";
  String mUserId = "";
  String mAmount = "";
  String mTxnId = "";
  String mCurrentData = "";
  bool isLastResultOrRePrintingOrCancelling = false;
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc>(
          create: (BuildContext context) => SignUpBloc(),
        )
      ],
      child: StatefulBuilder(
        builder: (context, state) {
          return BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state is RegistrationSuccess) {
                  Navigator.of(context).pop();
                  ShowToast.showToast( context, context.l10n.successfullyLogin, type: ToastType.SUCCESS);
                }
              },
              child: Dialog(
                elevation: 5.0,
                backgroundColor: LongaColor.white,
                insetPadding: EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 72.0, vertical: MediaQuery.of(context).size.width * 0.26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.cancel_outlined,
                          color: LongaColor.black,
                        ),
                      ).pOnly(top: 20, right: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        context.l10n.scan_qr_code,
                        style: TextStyle(
                            color: LongaColor.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width > 700
                          ? MediaQuery.of(context).size.width / 4
                          : MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          MobileScanner(
                            errorBuilder: (context, error, child) {

                              return ScannerError(
                                context: context,
                                error: error,
                              );
                            },
                            controller: _scanController,
                            onDetect: (capture) {
                              _scanController.stop();
                              try {
                                setState(() {
                                  List<Barcode> barcodes = capture.barcodes;
                                  String? validData = barcodes[0].rawValue;
                                  print("scan value -----> $validData");



                                  if (validData != null) {
                                    Map<String, String> proceedData = {};
                                    Uri uri = Uri.dataFromString(validData.toString());
                                    proceedData["t"] =
                                    uri.queryParameters['t']!;
                                    proceedData["t"] =
                                    uri.queryParameters['t']!;
                                    proceedData["t"] =
                                    uri.queryParameters['t']!;

                                    isInternetConnect().then((value) {
                                      if (value) {
                                        setState(() {
                                          isLastResultOrRePrintingOrCancelling = true;
                                          BlocProvider.of<SignUpBloc>(context).add(
                                              RegistrationUsingScan(
                                                  context: context,
                                                  username: "${proceedData["t"]}",
                                                  currencyCode: "CDF",
                                                  countryCode: "CD"
                                              )
                                          );
                                        });

                                      } else {
                                        _scanController.start();
                                        ShowToast.showToast(context,context.l10n.no_internet_available,type: ToastType.ERROR);
                                      }
                                    });


                                    // call api
                                  }
                                });
                              } catch (e) {
                                _scanController.start();

                                print("Something Went wrong with bar code: $e");
                              }
                            },
                          ),

                          Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  // on and off splash
                                  setState(() {
                                    flashOn = !flashOn;
                                    _scanController.toggleTorch();
                                    // controller?.toggleFlash();

                                    // _scanController.toggleTorchMode();
                                  });
                                },
                                child: Icon(
                                  (flashOn ? Icons.flash_on : Icons.flash_off),
                                  color: LongaColor.reddish_pink,
                                  size: 30,
                                ).p(10),
                              )),
                          _pendingWithdrawalLoader
                              ? const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator())
                              : Container(),
                          Visibility(
                            visible: isLastResultOrRePrintingOrCancelling,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: LongaColor.black.withOpacity(0.7),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Lottie.asset('assets/lottie/gradient_loading.json'))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
    );
  }


}
