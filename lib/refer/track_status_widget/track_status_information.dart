part of 'track_status_widget.dart';

class TrackStatusInformation extends StatelessWidget {
  const TrackStatusInformation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.trackStatusInformationText,
            style: TextStyle(
                color: LongaColor.brownish_grey_six,
                fontWeight: FontWeight.w400,
                fontFamily: "SegoeUI",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
            textAlign: TextAlign.center)
        .pOnly(
      left: 8,
      right: 8,
    );
  }
}
