import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/notification.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/common/widget/longa_text_field_underline.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_bloc.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_event.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_state.dart';
import 'package:longa_lotto/sign_up/model/request/registration_request.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class OtpScreen extends StatefulWidget {
  final Function? onLoginNavCallback;
  final Map<String, dynamic> userEnteredInfo;

  const OtpScreen({Key? key, this.onLoginNavCallback, required this.userEnteredInfo}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController   = TextEditingController();
  TextEditingController passController  = TextEditingController();
  ShakeController otpShakeController    = ShakeController();
  ShakeController passShakeController   = ShakeController();
  bool obscurePass                      = true;
  final _loginForm                      = GlobalKey<FormState>();
  var autoValidate                      = AutovalidateMode.disabled;
  var isOtpResendLoading                = false;
  bool isGenerateOtpButtonPressed       = false;
  bool showTimer                        = false;
  int currentSeconds                    = 0;
  static const interval                 = Duration(seconds: 1);
  Timer timer                           = Timer(interval, () {});
  final int timerMaxSeconds             = 121;
  double mAnimatedButtonSize = 300.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  get userInfo => null;

  @override
  void dispose() {

    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc> (
          create: (BuildContext context) => SignUpBloc(),
        )
      ],
      child: StatefulBuilder(
        builder: (BuildContext buildCtx, StateSetter setState){
          return BlocListener<SignUpBloc, SignUpState> (
            listener: (context, state) {
              setState((){
                if (state is RegistrationError) {
                  resetLoaderBtn();
                  ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
                } else if ( state is RegistrationSuccess) {
                  resetLoaderBtn();
                  currentSeconds = 0;
                  showTimer = false;
                  Navigator.popUntil(context, (route) => false);
                  Navigator.pushNamed(context, LongaScreen.homeScreen, arguments: true);
                  ShowToast.showToast(context, context.l10n.successfully_registered, type: ToastType.SUCCESS);
                  if (state.response != null) {

                    UserInfo.setRegistrationData(jsonEncode(state.response));
                    UserInfo.setRegistrationResponse();
                    UserInfo.setPlayerToken(state.response!.playerToken!);
                    UserInfo.setPlayerId(state.response!.playerLoginInfo!.playerId.toString());
                  }
                } else if (state is SendRegOtpError) {
                  isOtpResendLoading = false;
                  ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
                } else if( state is SendRegOtpSuccess) {
                  isOtpResendLoading = false;
                  startTimeout(interval);
                  showTimer = true;
                  var otp = state.response?.mobVerificationCode;
                  if (otp != null) {
                    PushNotification.show(otp: otp);
                  }
                }
              });
            },
            child: AbsorbPointer(
              absorbing: isOtpResendLoading,
              child: Dialog(
                elevation: 5.0,
                insetPadding: EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 74.0, vertical: 24.0),
                backgroundColor: LongaColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _loginForm,
                  autovalidateMode: autoValidate,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _gradientLine(),
                        const HeightBox(10),
                        Column(
                          children: [
                            _sendOtpTitle(),
                            const HeightBox(40),
                            _otpTextField(),
                            const HeightBox(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                (isOtpResendLoading == true)
                                    ? SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Lottie.asset('assets/lottie/resend_loader.json'),
                                ).pOnly(left: 3, right: 3)
                                    : _resendOtp(buildCtx)
                              ],
                            ),
                            const HeightBox(40),
                            _submitButton(buildCtx),
                            const HeightBox(10),
                            _cancelButton(),
                          ],
                        ).px24(),
                        const HeightBox(10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  _sendOtpTitle() {
    return Text(
      context.l10n.confirm_otp,
      style: TextStyle(
        color: LongaColor.black_four,
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: 22.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  _otpTextField() {
    return ShakeWidget(
      controller: otpShakeController,
      child: LongaTextFieldUnderline(
        maxLength: 6,
        inputType: TextInputType.number,
        hintText: context.l10n.please_enter_otp,
        controller: otpController,
        validator: (value) {
          if (validateInput(TotalTextFields.otp).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              otpShakeController.shake();
            }
            return validateInput(TotalTextFields.otp);
          } else {
            return null;
          }
        },
      ).pSymmetric(v: 8),
    );
  }

  startTimeout(Duration duration) {
    if (!mounted) return;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds){
          setState(() {
            showTimer = false;
          });
          timer.cancel();
        }
      });
    });
  }

  String get timerText {
    if (currentSeconds == 0) {
      return '';
    } else {
      return  ((timerMaxSeconds - currentSeconds) ~/ 60)
          .toString()
          .padLeft(2, '0') + " : " + ((timerMaxSeconds - currentSeconds) % 60)
          .toString()
          .padLeft(2, '0');
    }
  }

  _resendOtp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        showTimer
            ? Container(child: Text(timerText, style: TextStyle(color: LongaColor.shamrock_green,),),)
            : InkWell(
                onTap: () {
                  otpController.clear();
                  setState(() {
                    isOtpResendLoading = true;
                    //showTimer = true;
                  });
                  BlocProvider.of<SignUpBloc>(context).add(SendRegOtpEvent(context: context, mobileNo: widget.userEnteredInfo["mobileNo"]));
                },
                child: Text(
                  context.l10n.resend_otp,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: LongaColor.darkish_purple,
                    fontSize: 16.0,
                  ),
                ),
              )
      ],
    );
  }

  _submitButton(BuildContext context) {
    return AbsorbPointer(
      absorbing: !mButtonTextVisibility,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            isGenerateOtpButtonPressed = true;
          });
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              isGenerateOtpButtonPressed = false;
            });
          });
          if (_loginForm.currentState!.validate()) {
            setState((){
              mAnimatedButtonSize   = 50.0;
              mButtonTextVisibility = false;
            });
            BlocProvider.of<SignUpBloc>(context).add(
                RegistrationEvent(context: context,request:
                  RegistrationRequest(
                    countryCode: AppConstants.countryCode,
                    currencyCode: AppConstants.currencyCode,
                    domainName: AppConstants.domainName,
                    deviceType: AppConstants.deviceType,
                    emailId: null,
                    loginDevice: "ANDROID_APP_CASH",
                    mobileNo: widget.userEnteredInfo["mobileNo"],
                    userName: widget.userEnteredInfo["userName"],
                    otp: otpController.text.trim(),
                    password: widget.userEnteredInfo["password"],
                    registrationType: "FULL",
                    requestIp: AppConstants.requestIp,
                    userAgent: AppConstants.userAgent,
                    referCode: widget.userEnteredInfo["referCode"],
                    referSource: widget.userEnteredInfo["referCode"] != "" ? "REFER_FRIEND" : ""
                  )
                )
            );
          }
          else {
            setState(() {
              autoValidate = AutovalidateMode.onUserInteraction;
            });
          }
        },
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [LongaColor.butter_scotch, LongaColor.orangey_red,
                ]),
                borderRadius: BorderRadius.circular(67)
            ),
            child: AnimatedContainer(
              width: mAnimatedButtonSize,
              height: 50,
              onEnd: () {
                print("completed");
                setState(() {
                  if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                    mButtonShrinkStatus = ButtonShrinkStatus.started;

                  } else {
                    mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                  }
                });
              },
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                  width: mAnimatedButtonSize,
                  height: 50,
                  child: mButtonShrinkStatus == ButtonShrinkStatus.started
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: LongaColor.white_two),
                  )
                      : Center(child:
                  Visibility(
                    visible: mButtonTextVisibility,
                    child: Text(context.l10n.submit.toUpperCase(),
                      style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: LongaColor.white,
                      ),
                    ),
                  ))
              ),
            )
        ),
      ),
    );
  }

  _cancelButton() {
    return SecondaryButton(
      width: context.screenWidth / 2.5,
      height: context.screenHeight * 0.06,
      borderColor: LongaColor.darkish_purple,
      textColor: LongaColor.darkish_purple,
      // type: ButtonType.line_art,
      onPressed: () {
        Navigator.of(context).pop();
        // Navigator.pushNamed(context, Screen.registration_screen);
      },
      text: context.l10n.cancel.toUpperCase(),
      borderRadius: 67,
      // isDarkThemeOn: isDarkThemeOn,
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.otp:
        var otpText = otpController.text.trim();
        if (otpText.isEmpty) {
          return context.l10n.please_enter_your_otp;
        } else if (otpText.length < 6) {
          return context.l10n.otp_should_be_in_the_range;
        }
        break;
    }
    return "";
  }
}
