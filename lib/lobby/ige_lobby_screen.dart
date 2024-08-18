import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:longa_lotto/common/shadow_card.dart';
import 'package:longa_lotto/common/widget/longa_scaffold.dart';
import 'package:longa_lotto/common/widget/rounded_container.dart';
import 'package:longa_lotto/home/widget/home_widget.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:velocity_x/velocity_x.dart';

class IgeLobbyScreen extends StatefulWidget {
  final IgeGameResponse igeGameResponse;

  const IgeLobbyScreen({Key? key, required this.igeGameResponse})
      : super(key: key);

  @override
  State<IgeLobbyScreen> createState() => _IgeLobbyScreenState();
}

class _IgeLobbyScreenState extends State<IgeLobbyScreen> {
  List<Games?>? igeGameList;

  @override
  void initState() {
    igeGameList = widget.igeGameResponse.data?.ige?.engines?.lONGALOTTO?.games;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LongaScaffold(
      showAppBar: true,
      extendBodyBehindAppBar: true,
      appBarTitle: context.l10n.instantGames.toUpperCase(),
      body: RoundedContainer(
        child: AnimationLimiter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                childAspectRatio: 1 ,
                crossAxisCount: 2,
              ),
              itemCount: (igeGameList != null) ? igeGameList?.length : 0,
              itemBuilder: (_, index) {
                Games? igeGame = widget.igeGameResponse.data?.ige?.engines
                    ?.lONGALOTTO?.games?[index];
                LONGALOTTO? longalotto =
                    widget.igeGameResponse.data?.ige?.engines?.lONGALOTTO;
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 700),
                  columnCount: 3,
                  child: FlipAnimation(
                    flipAxis: FlipAxis.y,
                    child: FadeInAnimation(
                      child: ShadowCard(
                        child: Container(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
