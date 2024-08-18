import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/widget/alert/alert_type.dart';
import 'package:longa_lotto/common/widget/gradient_line.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:velocity_x/velocity_x.dart';

class Alert {
  static show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String buttonText,
    bool? isBackPressedAllowed,
    VoidCallback? buttonClick,
    bool isDarkThemeOn = true,
    bool? isCloseButton = false,
    AlertType? type = AlertType.error,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        AlertType alertType = type ?? AlertType.error;
        return WillPopScope(
          onWillPop: () async{
            return isBackPressedAllowed ?? true;
          },
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
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
                    buttons(isCloseButton ?? false, buttonClick, buttonText, ctx,
                        isDarkThemeOn),
                    const HeightBox(10),
                  ],
                ).pSymmetric(v: 20, h: 50),
              ],
            ),
          ),
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
        color:
            isDarkThemeOn ? LongaColor.white : LongaColor.black,
        fontSize: 16.0,
      ),
    );
  }

  static confirmButton(VoidCallback? buttonClick, String buttonText,
      BuildContext ctx, bool isDarkThemeOn) {
    return PrimaryButton(
      width: double.infinity,
      height: 52,
      fillDisableColor:
          isDarkThemeOn ? LongaColor.white : LongaColor.marigold,
      onPressed: buttonClick != null
          ? () {
              Navigator.of(ctx).pop();
              buttonClick();
            }
          : () {
              Navigator.of(ctx).pop();
            },
      text: buttonText,
      isDarkThemeOn: isDarkThemeOn,
    );
  }

  static buttons(bool isCloseButton, VoidCallback? buttonClick,
      String buttonText, BuildContext ctx, bool isDarkThemeOn) {
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
          child: confirmButton(buttonClick, buttonText, ctx, isDarkThemeOn),
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
        Navigator.of(ctx).pop();
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
        color = isDarkThemeOn
            ? LongaColor.butter_scotch
            : LongaColor.marigold;
        break;
      default:
        color = LongaColor.reddish_pink;
    }
    return color;
  }
}
