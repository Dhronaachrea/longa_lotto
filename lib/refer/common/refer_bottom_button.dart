import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/widget/longa_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ReferBottomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const ReferBottomButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      color: LongaColor.pale_grey_four,
      child: PrimaryButton(
        textColor: LongaColor.white,
        fillDisableColor: LongaColor.brownish_grey_six,
        text: title,
        textSize: 20,
        onPressed: onTap,
      ).pSymmetric(v: 5, h: 40),
    );
  }
}
