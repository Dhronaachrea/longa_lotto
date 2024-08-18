part of 'home_widget.dart';

class IgeGameCard extends StatefulWidget {
  final Size size;
  final String imagePath;
  final String gameName;
  final Games? igeGame;
  final int? index;
  final List<bool> flipList;
  final LONGALOTTO? longalotto;
  final Function(LONGALOTTO?, int?) callBack;

  IgeGameCard({
    Key? key,
    required this.size,
    required this.imagePath,
    required this.gameName,
    required this.igeGame,
    required this.longalotto,
    required this.index,
    required this.flipList,
    required this.callBack,
  }) : super(key: key);

  @override
  State<IgeGameCard> createState() => _IgeGameCardState();
}

class _IgeGameCardState extends State<IgeGameCard> {
  final gameNameTextStyle = const TextStyle(
    color: LongaColor.black_four,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 10,
  );

  final FlipCardController flipController = FlipCardController();

  List<bool> cardStates = List.generate(5, (index) => false);

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          print("clicking on . . . ${widget.index}");
          flipController.toggleCard();
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
          controller: flipController,
          fill: Fill.fillBack,
          side: CardSide.FRONT,
          direction: FlipDirection.HORIZONTAL,
          flipOnTouch: false,
          front: frontCardDetails(),
          back: backCardDetails(context),
          onFlip: () {
            print("onFlip");
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
            print("onFlipDone ----->$isFlipDone");

          },
        )
      ),
    );
  }

  frontCardDetails() {
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
                    width: widget.size.width * 0.30,
                    height: widget.size.height * 0.12,
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
                      imageUrl: widget.imagePath,
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
                          widget.gameName.toUpperCase(),
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
                            " ${widget.igeGame?.betList?[0] ?? "-"}",
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
                      Text(removeDecimalValueAndFormat(widget.igeGame?.gameWinUpto ?? "0"),
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

  backCardDetails(BuildContext context) {
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
              widget.gameName,
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
              "${UserInfo.currencyDisplayCode} ${widget.igeGame?.betList?[0] ?? "-"}",
              style: TextStyle(
                  fontSize: 12,
                  color: LongaColor.marigold,
                  fontWeight: FontWeight.w600
              ),
          ),
          SizedBox(height: 8,),

          Text(
              context.l10n.win_upto,
            style: TextStyle(
                fontSize: 10,
                color: LongaColor.white
            ),
          ),
          Text(
              "${UserInfo.currencyDisplayCode} ${removeDecimalValueAndFormat(widget.igeGame?.gameWinUpto ?? "0")}",
            style: TextStyle(
                fontSize: 12,
                color: LongaColor.marigold,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 8,),

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
                Navigator.pushNamed(context, LongaScreen.moreLinksWebViewScreen, arguments: ["igeKnowMore", widget.igeGame?.gameName]);
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
                  UserInfo.isLoggedIn()
                      ? Future.delayed(
                    const Duration(milliseconds: 100),
                        () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LongaWebView(
                            igeGame: widget.igeGame,
                            igeResponse: widget.longalotto,
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
