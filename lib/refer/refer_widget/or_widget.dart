part of 'refer_widget.dart';

class OrWidget extends StatelessWidget {
  const OrWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: LongaColor.pale_lilac,
              ),
            ),
          ),
        ).px16(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(context.l10n.or.toUpperCase(),
              style: TextStyle(
                  color: LongaColor.navy_blue,
                  fontWeight: FontWeight.w600,
                  fontFamily: "SegoeUI",
                  fontStyle: FontStyle.normal,
                  fontSize: 20),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
