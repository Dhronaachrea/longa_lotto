import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_event.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_state.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/alert/alert_type.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:velocity_x/velocity_x.dart';

class StateAlert {
  static bool isLoading = false;
  static var isGenerateOtpButtonPressed = false;
  static var mAnimatedButtonSize = 150.0;
  static var mButtonTextVisibility = true;
  static ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  static show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String buttonText,
    bool? isBackPressedAllowed,
    Function(BuildContext)? buttonClick,
    bool isDarkThemeOn = true,
    bool? isCloseButton = false,
    AlertType? type = AlertType.error,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        AlertType alertType = type ?? AlertType.error;
        return MultiBlocProvider(
            providers: [
              BlocProvider<LogoutBloc>(
                  create: (BuildContext context) => LogoutBloc()
              )
            ],
            child: StatefulBuilder(builder: (context, setState) {
              return BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state){
                  setState(() {
                    if (state is LogoutLoading) {
                      // ShowToast.showToast(context, context.l10n.logging_out_please_wait, type: ToastType.INFO);
                    }
                    else if(state is LogoutSuccess) {
                      resetStaticValues();
                    }
                    else if (state is LogoutError) {
                      ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
                      resetStaticValues();
                    }
                  });
                },
                child: WillPopScope(
                  onWillPop: () async {
                    return isBackPressedAllowed ?? true;
                  },
                  child: Dialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 74.0, vertical: 24.0),
                    backgroundColor: LongaColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isCloseButton ?? false ? _gradientLine() : Container(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const HeightBox(10),
                            alertIcon(isDarkThemeOn, alertType),
                            const HeightBox(10),
                            alertTitle(title, isDarkThemeOn, alertType),
                            const HeightBox(10),
                            alertSubtitle(subtitle, isDarkThemeOn),
                            const HeightBox(20),
                            isLoading ? CircularProgressIndicator() :
                            buttons(
                                isCloseButton ?? false,
                                buttonClick,
                                buttonText,
                                context,
                                isDarkThemeOn,
                                setState,
                                false),
                            const HeightBox(10),
                          ],
                        ).pSymmetric(v: 20, h: 50),
                      ],
                    ),
                  ),
                ),
              );
            })
        );
      },
    );
  }

  static alertIcon(bool isDarkThemeOn, AlertType type) {
    return Image.asset(
      "assets/icons/icon_confirmation.png",
      width: 60,
      height: 60,
    );
    /*return Image.asset(
      _getImagePath(isDarkThemeOn, type),
      width: 60,
      height: 60,
    );*/
  }

  static alertTitle(String title, bool isDarkThemeOn, AlertType type) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        color: _getTextColor(isDarkThemeOn, type),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static alertSubtitle(String subtitle, bool isDarkThemeOn) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isDarkThemeOn ? LongaColor.white : LongaColor.black,
        fontSize: 16.0,
      ),
    );
  }

  static confirmButton(Function(BuildContext)? buttonClick, String buttonText,
      BuildContext ctx, bool isDarkThemeOn, StateSetter setState) {
    // return PrimaryButton(
    //   width: double.infinity,
    //   height: 52,
    //   fillDisableColor:
    // //       isDarkThemeOn ? LongaColor.white : LongaColor.marigold,
    //   onPressed: buttonClick != null
    //       ? () {
    //     setState((){
    //       isShowCircle = true;
    //     });
    //           // Navigator.of(ctx).pop();
    //           // buttonClick();
    //         }
    //       : () {
    //           Navigator.of(ctx).pop();
    //         },
    //   text: buttonText,
    //   isDarkThemeOn: isDarkThemeOn,
    // );
    return AbsorbPointer(
      absorbing: !mButtonTextVisibility,
      child: InkWell(
        onTap: () {
          setState(() {
            isGenerateOtpButtonPressed = true;
            isLoading = true;
            mAnimatedButtonSize = 50.0;
            mButtonTextVisibility = false;
            mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
          });
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              isGenerateOtpButtonPressed = false;
            });
          });
          if (buttonClick != null) {
            // buttonClick(ctx);
            print("00000000000000000000000");
            BlocProvider.of<LogoutBloc>(ctx).add(LogoutApiEvent(context: ctx));
          } else {
            Navigator.of(ctx).pop();
          }
        },
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  LongaColor.butter_scotch,
                  LongaColor.orangey_red,
                ]),
                borderRadius: BorderRadius.circular(67)),
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
                          child: CircularProgressIndicator(
                              color: LongaColor.white_two),
                        )
                      : Center(
                          child: Visibility(
                          visible: mButtonTextVisibility,
                          child: FittedBox(
                            child: Text(
                              buttonText,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: LongaColor.white,
                              ),
                            ).p(2).pOnly(left: 3, right: 3),
                          ),
                        ))),
            )),
      ),
    );
  }

  static buttons(
    bool isCloseButton,
    Function(BuildContext)? buttonClick,
    String buttonText,
    BuildContext ctx,
    bool isDarkThemeOn,
    StateSetter setState,
    bool isLoading,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton
            ? Expanded(
                child: closeButton(ctx, isDarkThemeOn),
              )
            : const SizedBox(),
        isCloseButton ? const WidthBox(20) : const SizedBox(),
        Expanded(
          child: confirmButton(buttonClick, buttonText, ctx, isDarkThemeOn, setState),
        ),
      ],
    );
  }

  static closeButton(BuildContext ctx, bool isDarkThemeOn) {
    return PrimaryButton(
      width: double.infinity / 2,
      height: 52,
      fillDisableColor: LongaColor.white,
      fillEnableColor: LongaColor.white,
      textColor: LongaColor.tomato,
      onPressed: () {
        if(!isLoading) Navigator.of(ctx).pop();
      },
      borderColor: LongaColor.tomato,
      text: ctx.l10n.cancel,
      isCancelBtn: true,
      isDarkThemeOn: isDarkThemeOn,
    );
  }

  static _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  static _getTextColor(bool isDarkThemeOn, AlertType type) {
    Color color;
    switch (type) {
      case AlertType.success:
        color = LongaColor.shamrock_green;
        break;
      case AlertType.error:
        color = LongaColor.reddish_pink;
        break;
      case AlertType.warning:
        color = LongaColor.marigold;
        break;
      case AlertType.confirmation:
        color = isDarkThemeOn ? LongaColor.butter_scotch : LongaColor.marigold;
        break;
      default:
        color = LongaColor.reddish_pink;
    }
    return color;
  }

  static resetStaticValues() {
    isLoading = false;
    isGenerateOtpButtonPressed = false;
    mAnimatedButtonSize = 150.0;
    mButtonTextVisibility = true;
    mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  }
}
