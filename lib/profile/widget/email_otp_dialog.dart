import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/common/widget/longa_text_field_underline.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/profile/bloc/profile_bloc.dart';
import 'package:longa_lotto/profile/bloc/profile_event.dart';
import 'package:longa_lotto/profile/bloc/profile_state.dart';
import 'package:longa_lotto/profile/model/request/SendVerificationEmailRequest.dart';
import 'package:longa_lotto/profile/model/request/VerifyEmailWithOtpRequest.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class EmailOtpDialog extends StatefulWidget {
  const EmailOtpDialog({Key? key}) : super(key: key);

  @override
  State<EmailOtpDialog> createState() => _EmailOtpDialogState();
}

class _EmailOtpDialogState extends State<EmailOtpDialog> {
  TextEditingController otpController         = TextEditingController();
  ShakeController otpShakeController          = ShakeController();

  bool isOtpResendLoading                     = false;
  final _emailVerifyOtpForm                   = GlobalKey<FormState>();
  var autoValidate                            = AutovalidateMode.disabled;
  bool showTimer                              = false;
  int currentSeconds                          = 0;
  static const interval                       = Duration(seconds: 1);
  Timer timer                                 = Timer(interval, () {});
  final int timerMaxSeconds                   = 121;

  bool isGenerateOtpButtonPressed = false;

  double mAnimatedButtonSize = 300.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:  [
          BlocProvider<ProfileBloc> (
            create: (BuildContext context) => ProfileBloc(),
          ),
        ],
        child: StatefulBuilder(
          builder: (BuildContext buildCtx, StateSetter setState) {
            return BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state){
                setState(() {
                  if (state is VerifyEmailWithOtpSuccess) {
                    currentSeconds = 0;
                    showTimer = false;
                    var getSavedRegistrationData                        =   UserInfo.registrationData;
                    Map<String, dynamic> jsonMap                        =   jsonDecode(getSavedRegistrationData);
                    RegistrationResponse registrationResponse           =   RegistrationResponse.fromJson(jsonMap);
                    registrationResponse.playerLoginInfo?.emailVerified =   "Y";
                    BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(registrationResponse: registrationResponse),);
                    resetLoaderBtn();
                    Navigator.of(context).pop();
                    ShowToast.showToast(context, state.response.errorMessage.toString(), type: ToastType.SUCCESS);
                  } else if (state is VerifyEmailWithOtpError) {
                    resetLoaderBtn();
                    ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
                  } else if (state is SendVerificationEmailSuccess) {
                    isOtpResendLoading = false;
                    startTimeout(interval);
                    showTimer = true;
                    ShowToast.showToast(context, state.response.errorMessage.toString(), type: ToastType.SUCCESS);
                  } else if (state is SendVerificationEmailError) {
                    isOtpResendLoading = false;
                    ShowToast.showToast(context, state.errorMessage, type: ToastType.ERROR);
                  }
                });

              },
              child: AbsorbPointer(
                absorbing: isOtpResendLoading,
                child: Dialog(
                  elevation: 5.0,
                  insetPadding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  backgroundColor: LongaColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _emailVerifyOtpForm,
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
        )
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
      // context.l10n.loginOrSignup,
      context.l10n.otp_sent_successfully,
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
        hintText: context.l10n.enter_verification_code,
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
        // isDarkThemeOn: isDarkThemeOn,
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
                  setState(() {
                    isOtpResendLoading = true;
                    // is not resend otp
                  });
                  BlocProvider.of<ProfileBloc>(context).add(
                      SendVerificationEmailLink(
                          context: context,
                          isResendOtp: true,
                          request: SendVerificationEmailRequest(
                              domainName: AppConstants.domainName,
                              emailId: UserInfo.emailId,
                              isOtpVerification: "YES",
                              playerId: UserInfo.userId
                          )
                      ));
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
          setState(() {
            isGenerateOtpButtonPressed = true;
          });
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              isGenerateOtpButtonPressed = false;
            });
          });
          if (_emailVerifyOtpForm.currentState!.validate()) {
            setState(() {
              setState(() {
                mAnimatedButtonSize   = 50.0;
                mButtonTextVisibility = false;
              });
            });
            // submit api call
            BlocProvider.of<ProfileBloc>(context).add(
                VerificationEmailOtp(
                    context: context,
                    request: VerifyEmailWithOtpRequest(
                        domainName        : AppConstants.domainName,
                        emailId           : UserInfo.emailId,
                        merchantPlayerId  : UserInfo.userId,
                        otp               : otpController.text.trim()
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
      },
      text: context.l10n.cancel.toUpperCase(),
      borderRadius: 67,
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

  String validateInput(TotalTextFields textField) {
    switch(textField) {
      case TotalTextFields.otp :
        var oldText = otpController.text.trim();
        if (oldText.isEmpty) {
          return context.l10n.please_enter_otp;
        } if (oldText.length < 6) {
          return context.l10n.please_input_6_digit_verification_code;
        }
        break;
    }
    return "";
  }
}
