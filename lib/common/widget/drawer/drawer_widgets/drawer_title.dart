import "package:flutter/material.dart";
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerTitle extends StatelessWidget {
  final String title;

  const DrawerTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: LongaColor.warm_grey_seven,
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
      ).p(10),
    ).px4();
  }
}
