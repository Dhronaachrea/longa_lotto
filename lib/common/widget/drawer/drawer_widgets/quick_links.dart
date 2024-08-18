import 'package:flutter/material.dart';
import 'package:longa_lotto/common/widget/web_view/result_web_view.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'drawer_tile.dart';
import 'drawer_title.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerTitle(title: context.l10n.quickLinks.toUpperCase()),
        DrawerTile(
          heading: context.l10n.draw_game_result,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ResultWebView(),
              ),
            );
          },
        ),
      ],
    );
  }
}
