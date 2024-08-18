import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerGridTile extends StatelessWidget {
  final AssetImage icon;
  final String title;
  final VoidCallback? onTap;

  const DrawerGridTile({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              Navigator.pop(context);
              onTap!();
            }
          : () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 0.2),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
              width: 48,
              child: Image(image: icon),
            ).p(10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ).p(10),
          ],
        ),
      ),
    );
  }
}
