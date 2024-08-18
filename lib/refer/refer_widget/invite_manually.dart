part of 'refer_widget.dart';

class InviteManually extends StatelessWidget {
  const InviteManually({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6000000238418579,
      child: Text(context.l10n.inviteManually,
          style: TextStyle(
            color: LongaColor.brownish_grey_six,
            fontWeight: FontWeight.w400,
            fontFamily: "SegoeUI",
            fontStyle: FontStyle.normal,
            fontSize: 18,
          ),
          textAlign: TextAlign.center),
    );
  }
}
