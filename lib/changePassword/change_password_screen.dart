
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/changePassword/bloc/change_password_event.dart';
import 'package:longa_lotto/changePassword/bloc/change_password_state.dart';
import 'package:longa_lotto/changePassword/bloc/current_password_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/longa_text_field.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/common/widget/shake_animation.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_bloc.dart';
import 'package:longa_lotto/login/login_screen.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utils/auth/auth_bloc.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  TextEditingController oldPassController   = TextEditingController();
  TextEditingController newPassController   = TextEditingController();
  TextEditingController confPassController  = TextEditingController();
  bool obscureOldPass                       = true;
  bool obscureNewPass                       = true;
  bool obscureConfPass                      = true;
  final _changePassForm                     = GlobalKey<FormState>();
  bool isGenerateButtonPressed              = false;
  ShakeController oldPassShakeController    = ShakeController();
  ShakeController passShakeController       = ShakeController();
  ShakeController confPassShakeController   = ShakeController();
  bool isLoading    = false;
  var autoValidate  = AutovalidateMode.disabled;
  double mAnimatedButtonSize              = 300.0;
  bool mButtonTextVisibility              = true;
  ButtonShrinkStatus mButtonShrinkStatus  = ButtonShrinkStatus.notStarted;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        setState(() {
          if( state is ChangePasswordSuccess) {
            resetLoaderBtn();
            oldPassController.clear();
            newPassController.clear();
            confPassController.clear();
            Navigator.of(context).pop();//for closing change password screen
            Navigator.of(context).pop();// for closing drawer
            String msg = context.l10n.password_change_successfully;
            ShowToast.showToast(context, msg, type: ToastType.SUCCESS);
            BlocProvider.of<AuthBloc>(context).add(UserLogout());
            showDialog(
              context: context,
              builder: (context) => BlocProvider<LoginBloc>(
                create: (context) => LoginBloc(),
                child: const LoginScreen(),
              ),
            );
          } else if( state is ChangePasswordError) {
            resetLoaderBtn();
            ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
          }
        });
      },
      child: LongaScaffold(
        showAppBar: true,
        appBarTitle: context.l10n.changePassword.toUpperCase(),
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
                key: _changePassForm,
                autovalidateMode: autoValidate,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _oldPassTextField(),
                    _newPassTextField(),
                    _confirmPassTextField(),
                    _submitButton(),
                    ],
                  ).p32(),
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
  _oldPassTextField() {
    return ShakeWidget(
      controller: oldPassShakeController,
      child: LongaTextField(
        hintText: context.l10n.change_password_with_star,
        controller: oldPassController,
        inputType: TextInputType.text,
        maxLength: 16,
        suffixIcon: IconButton(
          icon: Icon(
            obscureOldPass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaColor.warm_grey_seven,
          ),
          onPressed: () {
            setState(() {
              obscureOldPass = !obscureOldPass;
            });
          },
        ),
        validator: (value) {
          if(validateInput(TotalTextFields.oldPassword).isNotEmpty) {
            if (isGenerateButtonPressed) {
              oldPassShakeController.shake();
            }
            return validateInput(TotalTextFields.oldPassword);
          } else {
            return null;
          }
        },
        obscureText: obscureOldPass,
      ).pSymmetric(v: 8),
    );
  }

  _newPassTextField() {
    return ShakeWidget(
      controller: passShakeController,
      child: LongaTextField(
        hintText: context.l10n.new_password_with_star,
        controller: newPassController,
        inputType: TextInputType.text,
        maxLength: 16,
        suffixIcon: IconButton(
          icon: Icon(
            obscureNewPass ? Icons.visibility_off : Icons.remove_red_eye_rounded,
            color: LongaColor.warm_grey_seven,
          ),
          onPressed: () {
            setState(() {
              obscureNewPass = !obscureNewPass;
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
        obscureText: obscureNewPass,
      ).pSymmetric(v: 8),
    );
  }

  _confirmPassTextField() {
    return ShakeWidget(
      controller: confPassShakeController,
      child: LongaTextField(
        hintText: context.l10n.confirm_password_with_star,
        controller: confPassController,
        inputType: TextInputType.text,
        maxLength: 16,
        validator: (value) {
          if(validateInput(TotalTextFields.confirmPassword).isNotEmpty) {
            if (isGenerateButtonPressed) {
              confPassShakeController.shake();
            }
            return validateInput(TotalTextFields.confirmPassword);
          } else {
            return null;
          }
        },
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
        obscureText: obscureConfPass,
      ).pSymmetric(v: 8),
    );
  }

  _submitButton() {
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
          if (_changePassForm.currentState!.validate()) {
              // call api
              setState((){
                mAnimatedButtonSize   = 50.0;
                mButtonTextVisibility = false;
              });

              BlocProvider.of<ChangePasswordBloc>(context).add(ChangePasswordApiEvent(context: context,oldPassword: oldPassController.text.trim(), newPassword: newPassController.text.trim()));

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
                    child: Text(context.l10n.update.toUpperCase(),
                      style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: LongaColor.white,
                      ),
                    ),
                  ))
              ),
            )
        ).pOnly(top: 30),
      ),
    );
  }

  resetLoaderBtn() {
    mAnimatedButtonSize   = 300.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus   = ButtonShrinkStatus.over;
  }

  String validateInput(TotalTextFields textField) {
    switch(textField) {
      case TotalTextFields.oldPassword :
        var oldText = oldPassController.text.trim();
        if (oldText.isEmpty) {
          return  context.l10n.please_enter_your_current_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(oldText)) {
          return context.l10n.allowed_special_character;
        } else if (oldText.length <= 7){
          return context.l10n.your_password_must_be_at_least_8_characters_long;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(oldText)) {
          return context.l10n.allowed_special_character;
        }

        break;

      case TotalTextFields.password:
        var passText = newPassController.text.trim();
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
        var passText      = newPassController.text.trim();
        var confPassText  = confPassController.text.trim();
        if (confPassText.isEmpty) {
          return context.l10n.please_retype_your_new_password_here;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(confPassText)) {
          return context.l10n.allowed_special_character;
        } else if (confPassText.length <= 7){
          return context.l10n.your_password_must_be_at_least_8_characters_long;
        } else if (passText != confPassText) {
          return context.l10n.this_should_be_same_as_your_new_password;
        } else if (!RegExp("^[a-zA-Z0-9!@#\$%()]*\$").hasMatch(confPassText)) {
          return context.l10n.allowed_special_character;
        }

        break;

      case TotalTextFields.mobileNumber:
        break;
    }
    return "";
  }
}
