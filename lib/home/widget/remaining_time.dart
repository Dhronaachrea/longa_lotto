part of 'home_widget.dart';
class RemainingTime extends StatelessWidget {
  const RemainingTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.remainingTime.toUpperCase(),
        style: const TextStyle(
            color: LongaColor.black_four,
            fontWeight: FontWeight.w700,
            fontFamily: "Arial",
            fontStyle: FontStyle.normal,
            fontSize: 13.0),
        textAlign: TextAlign.end);
  }
}
