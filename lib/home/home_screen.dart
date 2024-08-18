import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/common/widget/pull_to_refresh.dart';
import 'package:longa_lotto/home/bloc/dge/dge_game_bloc.dart';
import 'package:longa_lotto/home/bloc/ige/ige_game_bloc.dart';
import 'package:longa_lotto/home/widget/home_widget.dart';
import 'package:longa_lotto/inbox/bloc/inbox_bloc.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/utility/NetworkSingleton.dart';
import 'package:longa_lotto/utility/network_connection/network_bloc.dart';
import 'package:longa_lotto/utility/network_connection/network_state.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common/navigation/longa_screen.dart';
import '../common/widget/web_view/longa_web_view.dart';
import '../login/bloc/login_bloc.dart';
import '../login/login_screen.dart';
import '../utils/utils.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool afterNetGone = false;
  var gameImageUrls = [
    "assets/images/ige/game_treasure_hunt.png",
    "assets/images/ige/game_tic_tac_toe.png",
    "assets/images/ige/game_money_bee.png",
    "assets/images/ige/game_treasure_hunt.png",
    "assets/images/ige/game_tic_tac_toe.png",
    "assets/images/ige/game_money_bee.png",
  ];

  var gameNameList = [
    "Treasure Hunt",
    "Tic Tac Toe",
    "Money Bee",
    "Treasure Hunt",
    "Tic Tac Toe",
    "Money Bee",
  ];
  var igeScrollController = ScrollController();
  double offset = 0;
  var currentIndex = 0;
  IgeGameResponse? igeGameResponse;

  DgeGameResponse? dgeGameResponse;

  var scrollBarEnableScrollController = ScrollController();
  bool isScrollBarEnable = false;
  List<bool> flipList = [];
  bool isFlipDone = false;
  final FlipCardController flipController = FlipCardController();

  @override
  void initState() {
    BlocProvider.of<DgeGameBloc>(context)..add(FetchDgeGame(context: context));
    BlocProvider.of<IgeGameBloc>(context)..add(FetchIgeGame(context: context));
    if (UserInfo.isLoggedIn()) {
      BlocProvider.of<InboxBloc>(context)..add(GetInbox(offset: 0, context: context));
    }
    NetworkSingleton().setNetworkListener(context);
    scrollBarEnableScrollController.addListener(() {
      final nextPageTrigger = scrollBarEnableScrollController.position.minScrollExtent;
      if (scrollBarEnableScrollController.position.pixels ==  nextPageTrigger) {
        setState(() {
          isScrollBarEnable = false;
        });
      }
    });
    super.initState();
  }

  var cardKeys = Map<int, GlobalKey<FlipCardState>>();


  final gameNameTextStyle = const TextStyle(
    color: LongaColor.black_four,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 10,
  );

  @override
  Widget build(BuildContext context) {
    var gameTypeTextStyle = const TextStyle(
      color: LongaColor.black,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<NetworkBloc, NetworkState> (
        listener: (mContext, state) {
          if(state is NetWorkConnected) {
            setState(() {
              if (afterNetGone) {
                afterNetGone = false;
                ShowToast.showToast(context, context.l10n.internet_available, type: ToastType.SUCCESS);
                BlocProvider.of<DgeGameBloc>(context)..add(FetchDgeGame(context: context));
                BlocProvider.of<IgeGameBloc>(context)..add(FetchIgeGame(context: context));
              }
            });
          } else if(state is NetWorkNotConnected) {
            setState(() {
              afterNetGone = true;
            });
          }
        },
        child: PullToRefresh(
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
                  () {
                log("pull to refresh is called");
                BlocProvider.of<DgeGameBloc>(context)
                  ..add(FetchDgeGame(context: context));
                BlocProvider.of<IgeGameBloc>(context)
                  ..add(FetchIgeGame(context: context));
                if (UserInfo.isLoggedIn()) {
                  BlocProvider.of<InboxBloc>(context)..add(GetInbox(offset: 0, context: context));
                }
              },
            );
          },
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: HomeSliverAppBar(
                  expandedHeight: size.height * (isMobileDevice() ? 0.42 : 0.48),
                    mCallBack: (isCompleteScroll) {
                    if(isCompleteScroll){
                      WidgetsBinding.instance.addPostFrameCallback((_){
                        setState(() {
                          isScrollBarEnable = true;
                        });
                      });
                    }

                    }

                ),
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                      (context, index) => Container(
                        decoration: BoxDecoration(
                        /*borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),*/
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/home_white_bg.jpg',
                            ),
                            fit: BoxFit.fill
                        )
                    ),
                        child: Container(
                            width: size.width,
                            height: size.height * 0.9,// 660
                            padding: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      children: [
                                        BlocConsumer<DgeGameBloc, DgeGameState>(
                                          listener: (context, state){
                                            if (state is FetchDgeGameError) {
                                              ShowToast.showToast(
                                                  context, state.errorMessage.toString(),
                                                  type: ToastType.ERROR);
                                            }
                                          },
                                          builder: (context, state) {
                                            log("dge game state : $state");
                                            GameRespVo? dgeGame1;
                                            GameRespVo? dgeGame2;
                                            if (state is FetchedDgeGame) {
                                              dgeGameResponse = state.dgeGameResponse;
                                              dgeGame1 = dgeGameResponse
                                                  ?.responseData?.gameRespVOs
                                                  ?.firstWhere(
                                                      (element) => element.id == 3);
                                              dgeGame2 = dgeGameResponse
                                                  ?.responseData?.gameRespVOs
                                                  ?.firstWhere(
                                                      (element) => element.id == 2);
                                            }
                                            return state is FetchingDgeGame
                                                ? Container(
                                              height: size.height * 0.3,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  color: LongaColor.marigold,
                                                ),
                                              ),
                                            )
                                                : dgeGameResponse == null || dgeGame1 == null || dgeGame2 == null
                                                ? Container()
                                                : Column(
                                              children: [
                                                Text(
                                                  "- ${context.l10n.drawGames} -"
                                                      .toUpperCase(),
                                                  style: gameTypeTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    DgeGameCard(
                                                      size: size,
                                                      imagePath: dgeGame1
                                                          ?.gameCode ==
                                                          null
                                                          ? 'assets/images/game_12_by_24.png'
                                                          : 'assets/icons/my_tickets_game_image_1.png',
                                                      imageName:
                                                      dgeGame1?.gameName ??
                                                          "Game 1",
                                                      dgeGame: dgeGame1!,
                                                      currentTime:
                                                      dgeGameResponse!
                                                          .responseData!
                                                          .currentDate!,
                                                      onTimerCompleted: () {
                                                        log("first On timer completed is called");
                                                        var splashBloc =
                                                        BlocProvider.of<
                                                            DgeGameBloc>(
                                                            context);
                                                        splashBloc.add(
                                                            FetchDgeGame(
                                                                context:
                                                                context));

                                                      },
                                                    ),
                                                    DgeGameCard(
                                                      size: size,
                                                      imagePath: dgeGame2
                                                          ?.gameCode ==
                                                          null
                                                          ? 'assets/images/game_12_by_24.png'
                                                          : 'assets/icons/my_tickets_game_image_${dgeGame2?.id}.png',
                                                      imageName:
                                                      dgeGame2?.gameName ??
                                                          "Game 2",
                                                      dgeGame: dgeGame2!,
                                                      currentTime:
                                                      dgeGameResponse!
                                                          .responseData!
                                                          .currentDate!,
                                                      onTimerCompleted: () {
                                                        log("second On timer completed is called");
                                                        var splashBloc =
                                                        BlocProvider.of<
                                                            DgeGameBloc>(
                                                            context);
                                                        splashBloc.add(
                                                            FetchDgeGame(
                                                                context:
                                                                context));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        //ige game card
                                        BlocBuilder<IgeGameBloc, IgeGameState>(
                                          builder: (context, state) {
                                            log("ige game state : $state");
                                            if (state is FetchedIgeGame) {
                                              igeGameResponse = state.igeGameResponse;
                                            }
                                            return state is FetchingIgeGame
                                                ? Container(
                                              height: size.height * 0.3,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  color: LongaColor.marigold,
                                                ),
                                              ),
                                            )
                                                : igeGameResponse == null
                                                ? Container()
                                                : Column(
                                              children: [
                                                Divider(
                                                  color: LongaColor.black_four,
                                                  height: 20,
                                                ).pOnly(left: 20, right: 20, top: 13),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 5.0,
                                                  ),
                                                  child: Divider(
                                                    color: LongaColor
                                                        .pale_grey_three,
                                                    //color: Colors.red,
                                                    thickness: 2,
                                                  ),
                                                ),
                                                Text(
                                                  "- ${context.l10n.instantGames} -"
                                                      .toUpperCase(),
                                                  style: gameTypeTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  height: size.height * (isMobileDevice() ? 0.27 : 0.24),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {

                                                              if (igeScrollController
                                                                  .position
                                                                  .minScrollExtent !=
                                                                  offset &&
                                                                  offset > 16.0) {
                                                                offset = offset -
                                                                    (size.width *
                                                                        0.20 +
                                                                        16);
                                                              }
                                                              log("RIGHT CLICK minScrollExtent: ${igeScrollController.position.minScrollExtent}");
                                                              log("offset====$offset");
                                                              igeScrollController
                                                                  .animateTo(
                                                                  offset,
                                                                  duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                    100,
                                                                  ),
                                                                  curve: Curves
                                                                      .easeOut);
                                                            },
                                                            child: Container(
                                                              height: 90,
                                                              width: 30,
                                                              color: Colors.transparent,
                                                              child: Image.asset(
                                                                'assets/icons/left_arrow.png',
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: size.height *
                                                                0.06,
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 5.0),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          physics: AlwaysScrollableScrollPhysics(),
                                                          controller: igeScrollController,
                                                          scrollDirection: Axis.horizontal,
                                                          itemCount:
                                                          igeGameResponse!.data?.ige?.engines?.lONGALOTTO?.games?.length,
                                                          itemBuilder: (context, index) {
                                                            cardKeys.putIfAbsent(index, () => GlobalKey<FlipCardState>());
                                                            GlobalKey<FlipCardState>? thisCard = cardKeys[index];
                                                            List<Games> totalComingGames = igeGameResponse!.data?.ige?.engines?.lONGALOTTO?.games ?? [];
                                                            Games? igeGame =
                                                            igeGameResponse!.data?.ige?.engines?.lONGALOTTO?.games?[index];
                                                            LONGALOTTO? longalotto = igeGameResponse!.data?.ige?.engines?.lONGALOTTO;
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    print("clicking on . . . ${index}");
                                                                      setState(() {
                                                                        isFlipDone = true;
                                                                      });
                                                                    if (totalComingGames.isNotEmpty) {
                                                                      for(Games i in totalComingGames) {
                                                                        i.isCardFlipped = false;
                                                                      }
                                                                      igeGame.isCardFlipped = true;
                                                                    }

                                                                    for(Games i in totalComingGames) {
                                                                      if (i.isCardFlipped == true) {
                                                                        for(int i=0 ; i<totalComingGames.length ; i++) {
                                                                          if (cardKeys[i]?.currentState?.isFront != true) {
                                                                            cardKeys[i]?.currentState?.toggleCard();
                                                                          }
                                                                          thisCard?.currentState?.toggleCard();
                                                                        }
                                                                      }
                                                                    }
                                                                    /*if (widget.longalotto?.isCardFlipped == true) {
                                                                      widget.longalotto?.isCardFlipped = false;
                                                                      flipController.toggleCard();
                                                                    } else {
                                                                      widget.longalotto?.isCardFlipped = true;
                                                                    }
                                                                    flipController.toggleCard();

                                                                    print("on flip ----->${widget.index}");
                                                                    widget.callBack(widget.longalotto, widget.index);*/
                                                                  },
                                                                  child: FlipCard(
                                                                    key: thisCard,
                                                                    controller: flipController,
                                                                    fill: Fill.fillBack,
                                                                    side: CardSide.FRONT,
                                                                    direction: FlipDirection.HORIZONTAL,
                                                                    flipOnTouch: false,
                                                                    front: frontCardDetails(igeGame?.imagePath.toString() ?? gameImageUrls[index], igeGame!.gameName ?? "", igeGame),
                                                                    back: backCardDetails(context, igeGame.imagePath.toString() ?? gameImageUrls[index], igeGame.gameName ?? "",igeGame, longalotto, totalComingGames),
                                                                    onFlip: () {
                                                                      /*setState(() {
                                                                        isFlipDone = false;
                                                                      });*/
                                                                      print("onFlip");
                                                                      /*setState(() {
                                                                        isFlipDone = false;
                                                                      });*/
                                                                      // flipController.toggleCard();
                                                                      /*if (widget.longalotto?.isCardFlipped == true) {
                                                                       widget.longalotto?.isCardFlipped = false;
                                                                       flipController.toggleCard();
                                                                     } else {
                                                                       widget.longalotto?.isCardFlipped = true;
                                                                     }
                                                                      // flipController.toggleCard();
                                                                      print("on flip ----->${widget.index}");
                                                                      widget.callBack(widget.longalotto);*/
                                                                    },
                                                                    onFlipDone: (isFlipDone) {
                                                                      setState(() {
                                                                        isFlipDone = false;
                                                                      });

                                                                    },
                                                                  )
                                                              ),
                                                            );


                                                              IgeGameCard(
                                                              size: size,
                                                              imagePath: igeGame?.imagePath.toString() ?? gameImageUrls[index],
                                                              gameName: igeGame!.gameName!,
                                                              igeGame: igeGame,
                                                              longalotto: longalotto,
                                                              index: index,
                                                              flipList: flipList,
                                                              callBack: (LONGALOTTO? resp, int? flipindex) {
                                                                print("flipIndex ---------> $flipindex");
                                                                /*setState(() {
                                                                  int? gameLen = igeGameResponse?.data?.ige?.engines?.lONGALOTTO?.games?.length;
                                                                  for(var i=0; i < (gameLen ?? 0); i++) {
                                                                    if (i != flipindex) {

                                                                    }
                                                                    flipList.add(false);
                                                                  }
                                                                  // flipList[flipIndex!] = !flipList.elementAt(flipIndex!);
                                                                  igeGameResponse!
                                                                      .data
                                                                      ?.ige
                                                                      ?.engines
                                                                      ?.lONGALOTTO = resp;
                                                                  print("flip call back ------------->$resp");
                                                                });*/
                                                              }
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5.0),
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if (offset <=
                                                                  igeScrollController
                                                                      .position
                                                                      .maxScrollExtent) {
                                                                offset = offset +
                                                                    (size.width *
                                                                        0.20 +
                                                                        16);
                                                              }
                                                              log("left CLICK maxScrollExtent : ${igeScrollController.position.maxScrollExtent}");
                                                              log("offset====$offset");

                                                              igeScrollController
                                                                  .animateTo(
                                                                offset,
                                                                duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                    100),
                                                                curve:
                                                                Curves.easeIn,
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 90,
                                                              width: 30,
                                                              child: Image.asset(
                                                                'assets/icons/right_arrow.png',
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: size.height *
                                                                0.06,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        ///Bottom banner
                                        Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            height: size.height * (isMobileDevice() ? 0.20 : 0.27),
                                            width: size.width * 0.9,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(13),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  LongaColor.cerise,
                                                  LongaColor.tomato,
                                                  LongaColor.darkish_purple
                                                ],
                                                stops: [0.1, 0.8, 1],
                                              ),
                                              image: DecorationImage(
                                                image: ExactAssetImage('assets/images/home_bottom_banner.png'),
                                                  fit: BoxFit.fill
                                              )
                                            ),

                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  frontCardDetails(String imagePath, String gameName, Games? igeGame) {
    return Container(
      width: 143,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            colors: [
              LongaColor.marigold,
              LongaColor.tangerine,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp
        ),
      ),
      child: Stack(
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                  color: LongaColor.white,
                  borderRadius: BorderRadius.circular(7)

              ),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.30,
                    height: MediaQuery.of(context).size.height * 0.12,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [LongaColor.cerise, LongaColor.darkish_purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: LongaColor.black_16,
                          offset: Offset(0, 21),
                          blurRadius: 21,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: LongaColor.butter_scotch,
                          )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          gameName.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: gameNameTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Text(
                            UserInfo.currencyDisplayCode.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: LongaColor.black_four,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontSize: 7,
                            ),
                            textAlign: TextAlign.right,
                          ).pOnly(top: 3),
                          Text(
                            " ${igeGame?.betList?[0] ?? "-"}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: gameNameTextStyle,
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ],
                  ).pOnly(top: 6),
                ],
              ).p(10),
            ).p(8),
            Positioned(
              bottom: -20,
              right: 16,
              child: Container(
                height: 53,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      colors: [
                        LongaColor.marigold,
                        LongaColor.tangerine,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        context.l10n.win_upto.toUpperCase(),
                        style: TextStyle(
                            fontSize: 8,
                            color: LongaColor.black_5,
                            fontWeight: FontWeight.w600
                        ),


                      ).pOnly(top: 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          UserInfo.currencyDisplayCode.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: LongaColor.black,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 8,
                          ),
                        ),
                        Text(removeDecimalValueAndFormat(igeGame?.gameWinUpto ?? "0"),
                          style: TextStyle(
                            fontSize: 10,
                            color: LongaColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ).pOnly(bottom: 5, right: 6, left: 6),
                      ],
                    )
                  ],
                ).p(2),
              ),
            )
          ]
      ),
    );
  }

  backCardDetails(BuildContext context, String imagePath, String gameName, Games? igeGame, LONGALOTTO? longalotto, [List<Games>? totalComingGames]) {
    return Container(
      width: 143,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: LongaColor.black
      ),
      child: Column(
        children: [

          SizedBox(height: 15,),
          Text(
            gameName,
            style: TextStyle(
                fontSize: 10,
                color: LongaColor.white,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 11,),

          Text(
            "${context.l10n.ticket_amount}.",
            style: TextStyle(
                fontSize: 10,
                color: LongaColor.white
            ),),
          Text(
            "${UserInfo.currencyDisplayCode} ${igeGame?.betList?[0] ?? "-"}",
            style: TextStyle(
                fontSize: 12,
                color: LongaColor.marigold,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: isMobileDevice() ? 8 : 15,),

          Text(
            context.l10n.win_upto,
            style: TextStyle(
                fontSize: 10,
                color: LongaColor.white
            ),
          ),
          Text(
            "${UserInfo.currencyDisplayCode} ${removeDecimalValueAndFormat(igeGame?.gameWinUpto ?? "0")}",
            style: TextStyle(
                fontSize: 12,
                color: LongaColor.marigold,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: isMobileDevice() ? 8 : 15,),

          Container(
            width: 110,
            height: 29,
            child: OutlinedButton(

              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return LongaColor.white.withOpacity(0.2);
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return LongaColor.black;
                }),
                side: MaterialStateProperty.all(BorderSide(color: LongaColor.marigold, style: BorderStyle.solid)),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: LongaColor.white,
                    size: 15,
                  ),
                  Text(
                    context.l10n.know_more.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: LongaColor.white,
                    ),
                  )
                ],
              ),
              onPressed: () {

                for(Games i in totalComingGames ?? []) {
                  if (i.isCardFlipped == true) {
                    for(int i=0 ; i< (totalComingGames ?? []).length ; i++) {
                      if (cardKeys[i]?.currentState?.isFront != true) {
                        cardKeys[i]?.currentState?.toggleCard();
                      }
                    }
                  }
                }
                Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["igeKnowMore", igeGame?.gameName]);
              },
            ),
          ),
          SizedBox(height: 6,),

          Container(
            width: 110,
            height: 29,
            child: OutlinedButton(

              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return LongaColor.warm_grey_six.withOpacity(0.1);
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return LongaColor.marigold;
                }),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                ),
              ),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: LongaColor.black,
                      size: 20,
                    ),
                    Text(
                      context.l10n.play_know.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: LongaColor.black,
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () {
                //flipController.toggleCard();
                for(Games i in totalComingGames ?? []) {
                  if (i.isCardFlipped == true) {
                    for(int i=0 ; i< (totalComingGames ?? []).length ; i++) {
                      if (cardKeys[i]?.currentState?.isFront != true) {
                        cardKeys[i]?.currentState?.toggleCard();
                      }
                    }
                  }
                }
                UserInfo.isLoggedIn()
                    ? Future.delayed(
                  const Duration(milliseconds: 100),
                      () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LongaWebView(
                          igeGame: igeGame,
                          igeResponse: longalotto,
                        ),
                      ),
                    );
                  },
                )
                    : showDialog(
                  context: context,
                  builder: (context) => BlocProvider<LoginBloc>(
                    create: (context) => LoginBloc(),
                    child: const LoginScreen(),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
