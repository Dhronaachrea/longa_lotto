part of 'refer_widget.dart';

class InformationText extends StatelessWidget {
  const InformationText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.share_the_referral_code,
      style: TextStyle(
        color: LongaColor.brownish_grey_six,
        fontWeight: FontWeight.w400,
        fontFamily: "SegoeUI",
        fontStyle: FontStyle.normal,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }
}
