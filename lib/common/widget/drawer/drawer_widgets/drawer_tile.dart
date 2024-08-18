import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';

class DrawerTile extends StatelessWidget {
  final String heading;
  final IconData? icon;
  final AssetImage? image;
  final VoidCallback? onTap;
  final VoidCallback? onClick;
  final Widget? trailing;

  const DrawerTile({
    Key? key,
    required this.heading,
    this.icon,
    this.image,
    this.onTap,
    this.onClick,
    this.trailing,
  }) : super(key: key);

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
      child: ListTile(
        leading: image != null
            ? Image(
                width: 40,
                height: 40,
                image: image!,
              )
            : null,
        title: Text(
          heading,
          style: TextStyle(
              color:  LongaColor.black_four,
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle:  FontStyle.normal,
              fontSize: 13,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
        onTap: onClick != null
            ? () {
                onClick!();
              }
            : onTap != null
                ? () {
                    Navigator.pop(context);
                    onTap!();
                  }
                : () => Navigator.pop(context),
      ),
    );
  }
}
