part of 'reset_password_widget.dart';

class ResetPasswordTitle extends StatelessWidget {
  final bool isDarkThemeOn;

  const ResetPasswordTitle({Key? key, required this.isDarkThemeOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.resend_password,
      style: TextStyle(
        color: LongaColor.warm_grey_seven,
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
        fontStyle: FontStyle.normal,
        fontSize: 25.0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
