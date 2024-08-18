import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerGridTile extends StatelessWidget {
  final AssetImage icon;
  final String title;
  final VoidCallback? onTap;
  final bool? rightChild;
  final bool? leftChild;
  final bool? showCounter;

  const DrawerGridTile({
    Key? key,
    required this.icon,
    required this.title,
    this.rightChild,
    this.leftChild,
    this.showCounter = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unreadMsgCount  = int.parse(UserInfo.unRaedMsgCount.isNotEmpty ? (UserInfo.unRaedMsgCount ?? "0") : "0");
    Color sideColor = LongaColor.warm_grey_seven;
    double sideWidth = LongaConstant.accountGridBorderWidth;
    BorderSide customSide = BorderSide(
      color: sideColor,
      width: sideWidth,
    );
    BoxBorder rightChildBorder = Border(
      left: customSide,
      top: customSide,
      bottom: customSide,
    );
    BoxBorder leftChildBorder = Border(
      top: customSide,
      bottom: customSide,
      right: customSide,
    );

    return InkWell(
      onTap: onTap != null
          ? () {
              Navigator.pop(context);
              onTap!();
            }
          : () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          border: rightChild ?? false
              ? rightChildBorder
              : leftChild ?? false
                  ? leftChildBorder
                  : Border.all(
                      color: sideColor,
                      width: sideWidth,
                    ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeightBox(10),
            Stack(
              children: [
                SizedBox(
                height: 30,
                width: 48,
                child: Image(
                  image: icon,
                  color: LongaColor.black_four,
                ),
              ).p(10),
                (showCounter == true && unreadMsgCount > 0)
                    ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: LongaColor.reddish_pink
                  ),
                  child: Text(
                    UserInfo.unRaedMsgCount,
                    style: TextStyle(
                      color: LongaColor.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ).pSymmetric(v:2, h: 6),
                )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.transparent
                        ),
                        child: Text(
                          "",
                        ),
                      )
              ]
            ),
            FittedBox(
              child: Text(
                title,
                style: TextStyle(
                  color: LongaColor.black_four,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ).p(10),
            ),
            const HeightBox(10),
          ],
        ),
      ),
    );
  }
}
