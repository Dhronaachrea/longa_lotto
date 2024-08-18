part of 'reset_password_widget.dart';

class DrawLine extends StatelessWidget {

  const DrawLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: LongaColor.marigold,
        ),
      ),
    ).pSymmetric(v: 10);
  }
}
