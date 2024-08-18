part of 'home_widget.dart';

class DgeGameCard extends StatefulWidget {
  final Size size;
  final String imagePath;
  final String imageName;
  final GameRespVo dgeGame;
  final DateTime currentTime;
  final VoidCallback onTimerCompleted;

  const DgeGameCard({
    Key? key,
    required this.size,
    required this.imagePath,
    required this.imageName,
    required this.dgeGame,
    required this.currentTime,
    required this.onTimerCompleted,
  }) : super(key: key);

  @override
  State<DgeGameCard> createState() => _DgeGameCardState();
}

class _DgeGameCardState extends State<DgeGameCard> {
  @override
  Widget build(BuildContext context) {
    var gameNameTextStyle = const TextStyle(
      color: LongaColor.black_four,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontSize: 11,
    );

    // var imageHeight = size.height * 0.10;
    // var imageWidth = size.width * 0.35;
    var imageHeight = widget.size.width * 0.22;
    var imageWidth = widget.size.width * 0.22;

    print("-------------test"+widget.dgeGame.timeToFetchUpdatedGameInfo.toString());
    return InkWell(
      onTap: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LongaWebView(
                dgeGame: widget.dgeGame,
              ),
            ),
          );
        });
      },
      child: SizedBox(
        width: widget.size.width * 0.4,
        child: Column(
          children: [
            Container(
              width: imageWidth,
              height: imageHeight,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [LongaColor.butterscotch, LongaColor.tomato],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: LongaColor.black_10,
                    offset: Offset(0, 7),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Image.asset(
                widget.imagePath,
                // width: size.width * 0.18,
                // height: size.height * 0.10,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              width: imageWidth,
              child: Text(
                widget.imageName.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: gameNameTextStyle,
              ),
            ),
            //RemainingTime(),
            BlocProvider(
                create: (_) => HomeTimerBloc(),
                child: MyTimer(

                  drawDateTime: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                      widget.dgeGame.timeToFetchUpdatedGameInfo ??
                          "2023-09-10 00:00:00"),
                  currentDateTime: widget.currentTime,
                  gameName: widget.dgeGame.gameName,
                  callback: (newGameData) {
                    print("datas $newGameData");
                  },
                ).pOnly(left: 6, top: 8)
                // GameTimer(
                //   dgeGame: widget.dgeGame,
                //   currentTime: widget.currentTime,
                //   drawDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                //       widget.dgeGame.timeToFetchUpdatedGameInfo ??
                //           "2000-01-01 00:00:00"),
                //   onTimerCompleted: () {
                //     widget.onTimerCompleted();
                //   },
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
