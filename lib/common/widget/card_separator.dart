import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CardSeparator extends StatelessWidget {
  const CardSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
    );
  }
}
