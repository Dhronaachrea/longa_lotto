import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/notification.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/longa_text_field.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/otp/otp_screen.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_bloc.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_event.dart';
import 'package:longa_lotto/sign_up/bloc/sign_up_state.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController    = TextEditingController();
  TextEditingController mobController         = TextEditingController();
  TextEditingController passController        = TextEditingController();
  TextEditingController confPassController    = TextEditingController();
  TextEditingController referCodeController   = TextEditingController();
  ShakeController userNameShakeController     = ShakeController();
  ShakeController mobShakeController          = ShakeController();
  ShakeController passShakeController         = ShakeController();
  ShakeController confPassShakeController     = ShakeController();
  ShakeController referCodeShakeController    = ShakeController();

  bool isGenerateOtpButtonPressed = false;
  bool obscurePass                = true;
  bool obscureConfPass            = true;
  bool isLoading                  = false;
  bool isRegistrationLoading      = false;
  bool isBoxChecked               = false;
  var autoValidate                = AutovalidateMode.disabled;
  final _registrationForm         = GlobalKey<FormState>();
  double mAnimatedButtonSize              = 300.0;
  bool mButtonTextVisibility              = true;
  ButtonShrinkStatus mButtonShrinkStatus  = ButtonShrinkStatus.notStarted;
  // bool isUserNameExcessed = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        setState(() {
          if(state is CheckMobileNoAvailabilityError) {
            resetLoaderBtn();
            ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
            /*if( state.errorCode == 501 || state.errorCode == 505 || state.errorCode == 503) {

              *//*Timer(const Duration(milliseconds: 500), () {

              });*//*
              print("error checking ===============?> ${_registrationForm.currentState!.validate()}");
            if(_registrationForm.currentState!.validate()) {
              setState(() {
                print("hello------>");
                isUserNameExcessed = true;
              });
              autoValidate = AutovalidateMode.onUserInteraction;
            }

            }*/
          } else if (state is CheckMobileNoAvailabilitySuccess) {
            BlocProvider.of<SignUpBloc>(context).add(SendRegOtpEvent(context: context, mobileNo: mobController.text));

          } else if (state is SendRegOtpError) {
            resetLoaderBtn();
            ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);

          } else if( state is SendRegOtpSuccess) {
            resetLoaderBtn();
            _generateOtp();
            var otp = state.response?.mobVerificationCode;
            if (otp != null) {
              PushNotification.show(otp: otp);
            }

          }
        });
      },
      child: AbsorbPointer(
        absorbing: isLoading,
        child: SafeArea(
          child: LongaScaffold(
              showAppBar: true,
              appBarTitle: context.l10n.registration.toUpperCase(),
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
                          key: _registrationForm,
                          autovalidateMode: autoValidate,
                          child: CustomScrollView(
                            slivers: [
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  children: [
                                    const HeightBox(15),
                                    _userNameTextField(),
                                    _passTextField(),
                                    _confPassTextField(),
                                    _mobTextField(),
                                    _referAFriendTextField(),
                                    const HeightBox(30),
                                    _juvenileText(),
                                    const HeightBox(15),
                                    //_termAndCondition(),
                                    const HeightBox(30),
                                    _generateOtpButton(),
                                  ],
                                ).p20(),
                              ),
                            ],
                          )))
                ],
              )),
        ),
      ),
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

  _userNameTextField() {
    return ShakeWidget(
      controller: userNameShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 16,
        hintText: context.l10n.username_with_star,
        controller: userNameController,
        inputType: TextInputType.text,
        prefix: const Icon(
          Icons.manage_accounts,
          color: LongaColor.black_four,
        ),
        validator: (value) {
          if (validateInput(TotalTextFields.userName).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              userNameShakeController.shake();
            } else if (userNameController.text.trim().startsWith(RegExp("^[A-Za-z]+[A-Za-z0-9]{7,16}\$"))) {//^[A-Za-z0-9]{8,16}\$
              userNameShakeController.shake();
            }
            return validateInput(TotalTextFields.userName);
          } else {
            return null;
          }
        },
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _mobTextField() {
    return ShakeWidget(
      controller: mobShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        autoFocus: true,
        maxLength: 9,
        hintText: AppConstants.mobileCountryCode,
        controller: mobController,
        inputType: TextInputType.number,
        prefix: const Icon(
          Icons.phone_android,
          color: LongaColor.black_four,
        ),
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
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _passTextField() {
    return ShakeWidget(
      controller: passShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        hintText: context.l10n.password_with_star,
        controller: passController,
        obscureText: obscurePass,
        inputType: TextInputType.text,
        maxLength: 16,
        prefix: const Icon(
          Icons.vpn_key,
          color: LongaColor.black_four,
        ),
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
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _confPassTextField() {
    return ShakeWidget(
      controller: confPassShakeController,
      child: LongaTextField(
        borderColor: LongaColor.white,
        hintText: context.l10n.confirm_password_with_star,
        controller: confPassController,
        obscureText: obscureConfPass,
        inputType: TextInputType.text,
        maxLength: 16,
        validator: (value) {
          if (validateInput(TotalTextFields.confirmPassword).isNotEmpty) {
            if (isGenerateOtpButtonPressed) {
              confPassShakeController.shake();
            }
            return validateInput(TotalTextFields.confirmPassword);
          } else {
            return null;
          }
        },
        prefix: const Icon(
          Icons.vpn_key,
          color: LongaColor.black_four,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureConfPass
                ? Icons.visibility_off
                : Icons.remove_red_eye_rounded,
            color: LongaColor.black_four,
          ),
          onPressed: () {
            setState(() {
              obscureConfPass = !obscureConfPass;
            });
          },
        ),
        // isDarkThemeOn: isDarkThemeOn,
      ).pSymmetric(v: 8),
    );
  }

  _referAFriendTextField() {
    return ShakeWidget(
      controller: referCodeShakeController,
      child: LongaTextField(
        maxLength: 6,
        hintText: context.l10n.refer_promo_code,
        controller: referCodeController,
        inputType: TextInputType.text,
        prefix: Tab(icon: new Image.asset("assets/icons/account/high_five.png",color: LongaColor.black_four, width: 27, height: 27,)),
        validator: (value) {
          var referText = referCodeController.text.trim();
          if (referText.isEmpty) {
            //   return context.l10n.enterMobileNumber;
          }
          return null;
        },
      ).pSymmetric(v: 8),
    );
  }

  _juvenileText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: isBoxChecked,
          onChanged: (bool? value) {
            setState(() {
              isBoxChecked = value ?? false;
            });
          },
        )
        ,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: RichText(
                text: TextSpan(
                  text: context.l10n.i_acknowledge_that_i_am_18_yr_old_have_read_and_accept,
                  style: TextStyle(
                    color: LongaColor.black_four,
                    fontSize: 16.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: context.l10n.termsAndConditions,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: LongaColor.darkish_purple,
                          fontSize: 15.0,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["t&c"]);
                        }, // Handle the tap event
                    ),
                    TextSpan(text: context.l10n.and_the),
                    TextSpan(
                        text: context.l10n.privacyPolicy,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: LongaColor.darkish_purple,
                          fontSize: 15.0,
                        ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["privacyPolicy"]);
                      },
                    ),
                  ],
                ),
              ),
            ),
            /*Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                context.l10n.i_acknowledge_that_i_am_18_yr_old_have_read_and_accept,
                maxLines: 5,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: LongaColor.black_four,
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //Terms and Conditions and the Privacy Policy
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: FittedBox(
                child: Row(
                  children: [
                    _termAndCondition(),
                    Text(
                      context.l10n.and_the,
                      style: TextStyle(
                        color: LongaColor.black_four,
                        fontSize: 15.0,
                      ),
                    ),
                    _privacyPolicy()
                  ],
                ),
              ),
            )*/

          ],
        )

      ],
    );
  }

  _termAndCondition() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["t&c"]);
      },
      child: Text(
        context.l10n.termsAndConditions,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: LongaColor.darkish_purple,
          fontSize: 15.0,
        ),
      ),
    );
  }

  _privacyPolicy() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["privacyPolicy"]);

      },
      child: Text(
        context.l10n.privacyPolicy,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: LongaColor.darkish_purple,
          fontSize: 15.0,
        ),
      ),
    );
  }

  _generateOtpButton() {
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
          if (_registrationForm.currentState!.validate()) {
            //click check-box that you are at least 18 years old
            if (!isBoxChecked) {
              ShowToast.showToast(context, "${context.l10n.click_check_box_that_you_are_at_least_18_yr_old}", type: ToastType.ERROR);
            } else {
              setState((){
                mAnimatedButtonSize   = 50.0;
                mButtonTextVisibility = false;
              });
              BlocProvider.of<SignUpBloc>(context).add(CheckMobileNoAvailabilityBeforeRegisteringEvent(context: context, mobileNo: mobController.text.trim(), userName: userNameController.text.trim()));
            }

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
                    child: Text(context.l10n.generate_otp.toUpperCase(),
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

  String validateInput(TotalTextFields textField) {
    switch (textField) {

      case TotalTextFields.userName:
        var userName  = userNameController.text.trim();
        if (userName.isEmpty) {
          return context.l10n.please_enter_username;
        }else if (userName.length <= 7){
          return context.l10n.please_enter_at_least_8_characters;
        } else if (!RegExp("^[A-Za-z]+[A-Za-z0-9]{7,16}\$").hasMatch(userName)) { //^[A-Za-z0-9]{8,16}\$ //old one given by sir
          return context.l10n.only_alphanumeric_username_accepted;
        }
        break;

      case TotalTextFields.password:
        var passText = passController.text.trim();
        if (passText.isEmpty) {
          return  context.l10n.please_enter_your_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        } else if (passText.length <= 7){
          return context.l10n.password_length_should_be_between_8_to_16;
        }else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        }
        break;

      case TotalTextFields.confirmPassword:
        var passText = passController.text.trim();
        var confPassText = confPassController.text.trim();
        if (confPassText.isEmpty) {
          return context.l10n.please_re_enter_to_confirm_your_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(passText)) {
          return context.l10n.allowed_special_character;
        } else if (passText.length <= 7){
          return context.l10n.confirm_password_must_be_of_8_to_16_digits;
        } else if (passText != confPassText) {
          return context.l10n.confirm_password_not_equal_to_password_field;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(confPassText)) {
          return context.l10n.allowed_special_character;
        }
        break;

      case TotalTextFields.mobileNumber:
        var mobText = mobController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_mobile_number;
        } else if (!RegExp("^^[1-9][0-9]{8}\$").hasMatch(mobText)) {
          return context.l10n.please_provide_valid_mobile_number;
        }

        break;
    }
    return "";
  }

  Future _generateOtp() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Map<String, dynamic> userEnteredInfo = {
      "mobileNo"  : mobController.text.trim(),
      "userName"  : userNameController.text.trim(),
      "password"  : passController.text.trim(),
      "referCode" : referCodeController.text.trim()
    };
    return showDialog(
      context: context,
      builder: (mContext) => OtpScreen(
          userEnteredInfo: userEnteredInfo,
      ),
    );
  }
}
