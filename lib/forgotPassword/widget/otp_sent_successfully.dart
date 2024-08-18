part of 'reset_password_widget.dart';

class OtpSentSuccessfully extends StatelessWidget {
  final bool isDarkThemeOn;
  final String mobNumber;

  const OtpSentSuccessfully(
      {Key? key, required this.isDarkThemeOn, required this.mobNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.otp_successfully_send + " " + mobNumber,
      style: const TextStyle(
        color: LongaColor.darkish_purple,
        fontWeight: FontWeight.w400,
        fontFamily: "Roboto",
        fontStyle: FontStyle.italic,
        fontSize: 15,
      ),
      textAlign: TextAlign.left,
    );
  }
}
