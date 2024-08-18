import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/common/widget/longa_text_field_underline.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/bloc/login_event.dart';
import 'package:longa_lotto/login/bloc/login_state.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginNavCallback;

  const LoginScreen({Key? key, this.onLoginNavCallback}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  TextEditingController mobController   = TextEditingController();
  TextEditingController passController  = TextEditingController();
  ShakeController mobShakeController    = ShakeController();
  ShakeController passShakeController   = ShakeController();
  bool obscurePass        = true;
  final _loginForm        = GlobalKey<FormState>();
  var autoValidate        = AutovalidateMode.disabled;
  var isLoginLoading      = false;
  bool isGenerateOtpButtonPressed = false;

  FocusNode mobFocusNode   = FocusNode();
  FocusNode passFocusNode  = FocusNode();

  double mAnimatedButtonSize = 250.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (mContext, state) {
        setState(() {
          mAnimatedButtonSize   = 250.0;
          mButtonTextVisibility = true;
          mButtonShrinkStatus   = ButtonShrinkStatus.over;
        });
        if( state is LoginSuccess) {
          if(state.response != null) {
            if (widget.onLoginNavCallback != null) {
              Navigator.pop(context);
              widget.onLoginNavCallback!();
            } else {
              Navigator.pop(this.context);
            }
            BlocProvider.of<LoginBloc>(context).add(GetInbox(offset: 0, context: context));
            ShowToast.showToast(context,context.l10n.successfullyLogin, type: ToastType.SUCCESS);
          }
        } else if (state is LoginError) {
          ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);

        } else if (state is LoginLoading) {}
      },
      child: StatefulBuilder(builder: (context, setState) {
        return AbsorbPointer(
          absorbing: !mButtonTextVisibility,
          child: Dialog(
            elevation: 5.0,
            insetPadding:
                EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 74.0, vertical: 24.0),
            backgroundColor: LongaColor.white_five,
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
                        _loginOrSignUpTitle(),
                        const HeightBox(20),
                        _mobTextField(),
                        _passTextField(),
                        _forgotPass(),
                        const HeightBox(40),
                        _loginButton(),
                        const HeightBox(10),
                        _signUpButton(),
                      ],
                    ).px24(),
                    const HeightBox(10),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
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

  _loginOrSignUpTitle() {
    return FittedBox(
      child: Text(
        context.l10n.loginOrSignup,
        style: TextStyle(
          color: LongaColor.black_four,
          fontWeight: FontWeight.w600,
          fontFamily: "Roboto",
          fontStyle: FontStyle.normal,
          fontSize: 25.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _mobTextField() {
    return ShakeWidget(
      controller: mobShakeController,
      child: LongaTextFieldUnderline(
        maxLength: 16,
        inputType: TextInputType.text,
        hintText: context.l10n.username_and_mobile_no,
        controller: mobController,
        focusNode: mobFocusNode,
        onEditingComplete: () {
          if(mobController.text.isNotEmpty && passController.text.isEmpty) {
            passFocusNode.requestFocus();
          } else {
            proceedToLogin();
          }
        },
        validator: (value) {
          if (validateInput(TotalTextFields.mobileNumber).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              mobShakeController.shake();
            }
            return validateInput(TotalTextFields.mobileNumber);
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
      child: LongaTextFieldUnderline(
        // hintText: context.l10n.password,
        hintText: context.l10n.password,
        controller: passController,
        maxLength: 16,
        inputType: TextInputType.text,
        obscureText: obscurePass,
        focusNode: passFocusNode,
        onEditingComplete: () {
          proceedToLogin();
        },
        validator: (value) {
          if (validateInput(TotalTextFields.password).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              passShakeController.shake();
            }
            return validateInput(TotalTextFields.password);
          } else {
            return null;
          }
        },
        suffixIcon: IconButton(
          icon: Icon(
            obscurePass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaColor.black_four,
          ),
          onPressed: () {
            setState(() {
              obscurePass = !obscurePass;
            });
          },
        ),
      ).pSymmetric(v: 8),
    );
  }

  _forgotPass() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, LongaScreen.forgotPasswordScreen,);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            context.l10n.forgotPassword + "?",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: LongaColor.darkish_purple,
              fontSize: 16.0,
            ),
          )
        ],
      ),
    );
  }

  _loginButton() {
    return AbsorbPointer(
      absorbing: !mButtonTextVisibility,
      child: InkWell(
        onTap: () {
          proceedToLogin();
        },
        child: FittedBox(
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
                      child: Text(context.l10n.login.toUpperCase(),
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
      ),
    );
  }

  void proceedToLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      isGenerateOtpButtonPressed = true;
    });
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        isGenerateOtpButtonPressed = false;
      });
    });
    if (_loginForm.currentState!.validate()) {
      var password = passController.text.trim();
     /* if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(password)) {
        ShowToast.showToast(context,context.l10n.allowed_special_character);
      }*/
      setState(() {
        isLoginLoading        = true;
        mAnimatedButtonSize   = 50.0;
        mButtonTextVisibility = false;
        mButtonShrinkStatus   = ButtonShrinkStatus.notStarted;
      });
      BlocProvider.of<LoginBloc>(context).add(LoginPlayerEvent(context: context, userName: mobController.text, password: passController.text));
    }
    else {
      setState(() {
        autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _signUpButton() {
    return FittedBox(
      child: SecondaryButton(
        borderColor: LongaColor.darkish_purple,
        textColor: LongaColor.darkish_purple,
        width: context.screenWidth / 2.5,
        height: context.screenHeight * 0.06,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(
            context,
            LongaScreen.signUpScreen,
          );
        },
        text: context.l10n.signup.toUpperCase(),
        borderRadius: 50,
      ),
    );
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.mobileNumber:
        var mobText = mobController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_username;
        } else if (mobText.length <= 7 ) {
          return context.l10n.please_enter_at_least_8_characters;
        }
        break;

      case TotalTextFields.password:
        var passText = passController.text.trim();
        if (passText.isEmpty) {
          return  context.l10n.please_enter_your_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        }
        else if (passText.length <= 7) {
          return context.l10n.password_should_be_in_the_range;
        }
        break;

      case TotalTextFields.confirmPassword:
        break;
    }
    return "";
  }
}
