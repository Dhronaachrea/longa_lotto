import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';

class GradientLine extends StatelessWidget {
  final double? height;
  final BorderRadius? borderRadius;

  const GradientLine({Key? key, this.height, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 10.0,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(0)),
        gradient: LinearGradient(
          begin: Alignment(1, 0),
          end: Alignment(0, 1),
          colors: [
            LongaColor.marigold,
            LongaColor.tangerine,
          ],
        ),
      ),
    );
  }
}
