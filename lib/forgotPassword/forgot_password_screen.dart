import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/longa_text_field.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_state.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_bloc.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_event.dart';
import 'package:longa_lotto/forgotPassword/model/request/reset_password_request.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController mobController         = TextEditingController();
  final _forgotPasswordForm                   = GlobalKey<FormState>();
  final _resetPasswordForm                    = GlobalKey<FormState>();
  ShakeController mobShakeController          = ShakeController();
  ShakeController otpShakeController          = ShakeController();
  ShakeController passShakeController         = ShakeController();
  ShakeController confirmPassShakeController  = ShakeController();
  TextEditingController passController        = TextEditingController();
  TextEditingController confPassController    = TextEditingController();
  TextEditingController otpController         = TextEditingController();
  bool obscurePass      = true;
  bool obscureConfPass  = true;
  var autoValidate      = AutovalidateMode.disabled;
  bool isRequestForOtpLoading           = false;
  bool isRequestForVerifyOtpLoading     = false;
  bool isGenerateButtonPressed          = false;
  bool isOtpSendForForgotPassword       = false;
  double mAnimatedButtonSize            = 300.0;
  bool mButtonTextVisibility            = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  var isOtpResendLoading                = false;
  bool showTimer                        = false;
  static const interval                 = Duration(seconds: 1);
  Timer timer                           = Timer(interval, () {});
  int currentSeconds                    = 0;
  final int timerMaxSeconds             = 121;

  @override
  void dispose() {
    mobController.dispose();
    mobShakeController.dispose();
    passController.dispose();
    confPassController.dispose();
    otpController.dispose();
    otpShakeController.dispose();
    passShakeController.dispose();
    confirmPassShakeController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        setState(() {
          if (state is ForgotPasswordLoading) {
            isRequestForOtpLoading      = true;
            showTimer = false;
          } else if (state is ForgotPasswordSuccess) {
               setState(() {
                 currentSeconds = 0;
                 showTimer = true;
                 startTimeout(interval);
               });
            ShowToast.showToast(context, context.l10n.verification_code_to_reset_your_password_has_been_sent , type: ToastType.SUCCESS);
            isOtpSendForForgotPassword  = true;
            isRequestForOtpLoading      = false;
            isOtpResendLoading = false;

            resetLoaderBtn();
          } else if (state is ForgotPasswordError) {
            ShowToast.showToast(context, state.errorMessage.toString() , type: ToastType.ERROR);
            resetLoaderBtn();
            ShowToast.showToast(context, state.errorMessage.toString() , type: ToastType.ERROR);

          } else if ( state is ResetPasswordError) {
            isRequestForOtpLoading      = false;
            resetLoaderBtn();
            ShowToast.showToast(context, state.errorMessage.toString() , type: ToastType.ERROR);

          } else if ( state is ResetPasswordSuccess) {
            isOtpSendForForgotPassword  = true;
            isRequestForOtpLoading      = false;
            resetLoaderBtn();
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (context) => BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(),
                  child: const LoginScreen(),
                )
            );
            ShowToast.showToast(context, context.l10n.you_have_successfully_reset_your_password , type: ToastType.SUCCESS);
          }
        });

      },
      child: isOtpSendForForgotPassword
          ? AbsorbPointer(
        absorbing: isRequestForOtpLoading,
        child: SafeArea(
          child: LongaScaffold(
              showAppBar: true,
              appBarTitle: context.l10n.forgotPassword.toUpperCase(),
              extendBodyBehindAppBar: true,
              showLoginBtnOnAppBar: false,
              body: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle, // BoxShape.circle or BoxShape.retangle
                    //color: const Color(0xFF66BB6A),
                    boxShadow: [BoxShadow(
                      color: LongaColor.warm_grey_seven,
                      blurRadius: 0.0,
                    ),]
                ),
                child: WillPopScope(
                  onWillPop: () async{
                    return !isRequestForVerifyOtpLoading;
                  },
                  child: Dialog(
                    insetPadding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 24.0),
                    backgroundColor:LongaColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: _resetPasswordForm,
                      autovalidateMode: autoValidate,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _gradientLine(),
                            const HeightBox(40),
                            Column(
                              children: [
                                const HeightBox(20),
                                _otpTextField(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _resendOtp(context),
                                    if (isOtpResendLoading == true)
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Lottie.asset('assets/lottie/resend_loader.json'),
                                      ).pOnly(left: 3, right: 3)
                                  ],
                                ),

                                _passTextField(),
                                _confPassTextField(),
                                const HeightBox(10),
                                isRequestForOtpLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: LongaColor.marigold,
                                          strokeWidth: 3.5,
                                        )
                                    )
                                : buttons(context),
                                const HeightBox(20),
                              ],
                            ).px(12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ),
        ),
      )
          : LongaScaffold(
          showAppBar: true,
          appBarTitle: context.l10n.forgotPassword.toUpperCase(),
          extendBodyBehindAppBar: true,
          showLoginBtnOnAppBar: false,
          body: Stack(
            children: [
              Container(
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/app_bg.webp",
                    ),
                  ),
                ),
              ),
              RoundedContainer(
                  child: Form(
                      key: _forgotPasswordForm,
                      autovalidateMode: autoValidate,
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _mobTextField(),
                                const HeightBox(30),
                                _sendOtpButton(),
                              ],
                            ).p20(),
                          ),
                        ],
                      )))
            ],
          )
      ),
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

  _mobTextField() {
    return ShakeWidget(
      controller: mobShakeController,
      child: LongaTextField(
        maxLength: 9,
        // hintText: context.l10n.mobile_number_with_star,
        hintText: "+243",
        controller: mobController,
        inputType: TextInputType.number,
        prefix: const Icon(
          Icons.phone_android,
          color: LongaColor.warm_grey_seven,
        ),
        validator: (value) {
          var mobText = mobController.text.trim();
          if (mobText.isEmpty) {
            mobShakeController.shake();
            return context.l10n.please_enter_your_mobile_number;
          } else if (mobController.text.length < 9){
            return context.l10n.mobile_number_should_be_in_range;
          } else if (!RegExp("^[0-9]{9}\$").hasMatch(mobText)) {
            mobShakeController.shake();
            return context.l10n.please_provide_valid_mobile_number;
          }
          return null;
        },
      ).pSymmetric(v: 8),
    );
  }

  _sendOtpButton() {
    return AbsorbPointer(
      absorbing: !mButtonTextVisibility,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            isGenerateButtonPressed = true;
          });
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              isGenerateButtonPressed = false;
            });
          });
          if (_forgotPasswordForm.currentState!.validate()) {
            var mobNumber = mobController.text.trim();
            setState(() {
              mAnimatedButtonSize   = 50.0;
              mButtonTextVisibility = false;
            });
            context.read<ForgotPasswordBloc>().add(ForgotPasswordApiEvent(context: context, mobileNo: mobNumber),);
          } else {
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

  _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  _otpTextField() {
    return ShakeWidget(
      controller: otpShakeController,
      child: LongaTextField(
        hintText: context.l10n.one_time_otp,
        controller: otpController,
        maxLength: 6,
        inputType: TextInputType.number,
        prefix: const Icon(
          Icons.message,
          color: LongaColor.warm_grey_seven,
        ),
        validator: (value) {
          if(validateInput(TotalTextFields.otp).isNotEmpty) {
            if (isGenerateButtonPressed) {
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

  _passTextField() {
    return ShakeWidget(
      controller: passShakeController,
      child: LongaTextField(
        hintText: context.l10n.password,
        controller: passController,
        maxLength: 16,
        prefix: const Icon(
          Icons.lock,
          color: LongaColor.warm_grey_seven,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaColor.warm_grey_seven,
          ),
          onPressed: () {
            setState(() {
              obscurePass = !obscurePass;
            });
          },
        ),
        validator: (value) {
          if(validateInput(TotalTextFields.password).isNotEmpty) {
            if (isGenerateButtonPressed) {
              passShakeController.shake();
            }
            return validateInput(TotalTextFields.password);
          } else {
            return null;
          }
        },
        obscureText: obscurePass,
      ).pSymmetric(v: 8),
    );
  }

  _confPassTextField() {
    return ShakeWidget(
      controller: confirmPassShakeController,
      child: LongaTextField(
        hintText: context.l10n.confirm_password,
        controller: confPassController,
        prefix: const Icon(
          Icons.lock,
          color: LongaColor.warm_grey_seven,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureConfPass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaColor.warm_grey_seven,
          ),
          onPressed: () {
            setState(() {
              obscureConfPass = !obscureConfPass;
            });
          },
        ),
        validator: (value) {
          if(validateInput(TotalTextFields.confirmPassword).isNotEmpty) {
            if (isGenerateButtonPressed) {
              confirmPassShakeController.shake();
            }
            return validateInput(TotalTextFields.confirmPassword);
          } else {
            return null;
          }
        },
        obscureText: obscureConfPass,
      ).pSymmetric(v: 8),
    );
  }

  buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: cancelButton(context),
        ),
        const WidthBox(20),
        Expanded(
          child: submitButton(context),
        ),
      ],
    );
  }

  cancelButton(BuildContext context) {
    return AbsorbPointer(
      absorbing: isRequestForVerifyOtpLoading,
      child: PrimaryButton(
        width: double.infinity / 2,
        fillDisableColor: Colors.transparent,
        fillEnableColor: Colors.transparent,
        onPressed: () {
          timer.cancel();
          setState(() {
            isOtpSendForForgotPassword = false;

          });

          otpController.clear();
          passController.clear();
          confPassController.clear();

        },
        borderColor: LongaColor.warm_grey_six,
        borderRadius: 10,
        isCancelBtn: true,
        textColor: LongaColor.warm_grey_six,
        text: context.l10n.cancel,
      ),
    );
  }

  submitButton(BuildContext context) {
    return
      isRequestForVerifyOtpLoading
          ?  SizedBox(width: 60, height: 60, child: Lottie.asset('assets/lottie/gradient_loading.json'))
          :  PrimaryButton(
                width: double.infinity,
                fillDisableColor: LongaColor.marigold,
                fillEnableColor: LongaColor.marigold,
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());

                  {
                    setState(() {
                      isGenerateButtonPressed = true;
                    });
                    Timer(const Duration(milliseconds: 500), () {
                      setState(() {
                        isGenerateButtonPressed = false;
                      });
                    });
                    if (_resetPasswordForm.currentState!.validate()) {
                      timer.cancel();
                      context.read<ForgotPasswordBloc>().add(
                          ResetPasswordApiEvent(context: context,
                          request: ResetPasswordRequest(
                            otp             : otpController.text.trim(),
                            newPassword     : passController.text.trim(),
                            confirmPassword : confPassController.text.trim(),
                            mobileNo        : mobController.text.trim(),
                            domainName      : AppConstants.domainName
                          )
                        ),
                      );
                    } else {
                      setState(() {
                        autoValidate = AutovalidateMode.onUserInteraction;
                      });
                    }
                  }
                },
                borderRadius: 10,
                text: context.l10n.submit,
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
        } else if (oldText.length < 6) {
          return context.l10n.otp_should_be_in_the_range;
        }
        break;

      case TotalTextFields.password:
        var passText = passController.text.trim();
        if (passText.isEmpty) {
          return  context.l10n.please_enter_your_new_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        } else if (passText.length <= 7){
          return context.l10n.your_password_must_be_at_least_8_characters_long;
        }else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        }
        break;

      case TotalTextFields.confirmPassword:
        var passText      = passController.text.trim();
        var confPassText  = confPassController.text.trim();

        if (confPassText.isEmpty) {
          return context.l10n.please_re_enter_to_confirm_your_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(confPassText)) {
          return context.l10n.allowed_special_character;
        } else if (confPassText.length <= 7){
          return context.l10n.confirm_password_must_be_of_8_to_16_digits;
        } else if (passText != confPassText) {
          return context.l10n.confirm_password_is_not_equal_to_password_field;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(confPassText)) {
          return context.l10n.allowed_special_character;
        }
        break;

      case TotalTextFields.mobileNumber:
        break;

      case TotalTextFields.oldPassword:
        break;
    }
    return "";
  }
  _resendOtp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        showTimer? Container(child: Text(timerText, style: TextStyle(color: LongaColor.shamrock_green,),),): InkWell(
          onTap: () {
            otpController.clear();
            setState(() {
              isOtpResendLoading = true;
              showTimer = true;
            });
            context.read<ForgotPasswordBloc>().add(ForgotPasswordApiEvent(context: context, mobileNo: mobController.text.trim()),);

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

}
