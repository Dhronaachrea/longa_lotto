import "package:flutter/material.dart";
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'drawer_tile.dart';
import 'drawer_title.dart';

class MoreLinks extends StatelessWidget {
  const MoreLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DrawerTitle(title: context.l10n.moreLinks.toUpperCase()),
        DrawerTile(
          heading: context.l10n.termsAndConditions,
          onTap: () {
            Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["t&c"]);
          },
        ),
        DrawerTile(
          heading: context.l10n.privacyPolicy,
          onTap: () {
            Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["privacyPolicy"]);
          }
        ),
      ],
    );
  }
}
