import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child;

  const RoundedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.3,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/images/bg_banner.webp",
              ),
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          height: size.height,
          width: double.infinity,
          margin: EdgeInsets.only(top: size.height * 0.13),
          //padding: EdgeInsets.only(top: size.height * 0.01),
          decoration: BoxDecoration(
              color: LongaColor.pale_grey_three,
              boxShadow: [BoxShadow(blurRadius: 25.0)],
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50))),
          child: child,
        ),
      ],
    );
  }
}
