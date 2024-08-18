part of 'refer_widget.dart';

class ReferInformationText extends StatelessWidget {
  const ReferInformationText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.bonusEligibilityText + "\n\n" + context.l10n.howToShareText,
      style: TextStyle(
        color: LongaColor.brownish_grey_six,
        fontWeight: FontWeight.w400,
        fontFamily: "SegoeUI",
        fontStyle: FontStyle.normal,
        fontSize: 18.0,
      ),
      textAlign: TextAlign.center,
    ).px16();
  }
}
