import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:longa_lotto/common/blinking_animation.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/home/bloc/dge/dge_game_bloc.dart';
import 'package:longa_lotto/home/logic/home_logic.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/utils/user_info.dart';

typedef GameResponseCallback = void Function(String date);

class MyTimer extends StatefulWidget {
  MyTimer(
      {Key? key,
      required this.callback,
      required this.currentDateTime,
      required this.drawDateTime,
      this.gameName})
      : super(key: key);

  final GameResponseCallback callback;
  DateTime? drawDateTime;
  DateTime? currentDateTime;
  String? gameName;

  @override
  State<MyTimer> createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  static const duration = Duration(seconds: 1);
  DateTime drawDate = DateTime(0);
  Map<String, dynamic> drawRequest = {};
  Map<String, dynamic> sportRequest = {};
  Map<String, dynamic> bingoRequest = {};
  var timeDiff = 0.toSigned(64);
  bool isApiReadyToCall = true;
  bool isTimerRespGet = false;
  //ShakeController hurryUpShakeController = ShakeController();

  Timer timer = Timer(duration, () {});

  @override
  void initState() {
    //initlizeTimer(widget.drawDateTime!, widget.currentDateTime!);
    super.initState();
    _callDge();
  }

  _callDge() async {
    var response = await HomeLogic.callFetchDgeGame(
      context,
      {
        "domainCode": "www.longagames.com",
        "field": ["BET_INFO", "DRAW_INFO"],
        "gameCodes": ["DailyLotto2", "EightByTwentyFour"],//FiveByFortyNineLottoWeekly
        "lastTicketNumber": "",
        "numberOfDraw": 0,
        "playerCurrencyCode": UserInfo.currencyDisplayCode,
        "playerId": UserInfo.userId,
        "retailerId": 12010,
        "sessionId": "611C9B883826B5091BC99E2CADE2075C"
      },
    );
    try {
      response.when(
          responseSuccess: (value) {
            log("bloc success");
            DgeGameResponse dgeGameResponse = value as DgeGameResponse;
            blocDgeGameResponse = dgeGameResponse;
            dgeGameResponse.responseData?.gameRespVOs?.forEach((element) {
              setState(() {
                isTimerRespGet = true;
              });
              if (widget.gameName == element.gameName) {
                initlizeTimer(
                  DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                      element.timeToFetchUpdatedGameInfo ??
                          "2023-01-01 00:00:00"),
                  DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                      dgeGameResponse.responseData?.currentDate?.toString() ??
                          "2023-02-01 00:00:00"),
                );
              }
            });
          },
          idle: () {},
          networkFault: (value) {},
          responseFailure: (value) {},
          failure: (value) {});
    } catch (e) {}
  }

  _handleTick() {
    if (!mounted) return;
    setState(() {
      if (timeDiff > 0) {
        isApiReadyToCall = true;
        if (drawDate != widget.currentDateTime) {
          timeDiff = timeDiff - 1;
        } else {
          isApiReadyToCall = true;
        }
      } else {
        if (isApiReadyToCall) {
          print('Times up!');
          isApiReadyToCall = false;
          // widget.callback("");
          _callDge();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int days = timeDiff ~/ (24 * 60 * 60);
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;

    String strDays    = (days == 0) ? '' : days.toString().padLeft(2, '0') + ' D ';
    String strHours   = (hours == 0) ? '' : hours.toString().padLeft(2, '0') + ' H ';
    String strMinutes = minutes.toString().padLeft(2, '0') + ' M ';
    String strSeconds = seconds.toString().padLeft(2, '0') + ' S';
    /*if (widget.drawDateTime != null &&
        (days == 0 && hours == 0 && minutes < 1)) {
      try {
        hurryUpShakeController.shake();
      } catch (e) {}
    }*/
    String finalTimeStr = "";
    if (strDays.isNotEmpty) {
      finalTimeStr = '$strDays : $strHours : $strMinutes : $strSeconds';
    } else if (strHours.isNotEmpty){
      finalTimeStr = '$strHours : $strMinutes : $strSeconds';
    } else {
      finalTimeStr = '$strMinutes : $strSeconds';
    }



    return (days == 0 &&
        hours == 0 &&
        minutes == 0 &&
        seconds <= 0 &&
        !isApiReadyToCall)
        ? Center(
            child: CircularProgressIndicator(
              color: LongaColor.marigold,
            ),
          )
        : isTimerRespGet
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (widget.drawDateTime != null && (days == 0 && hours == 0 && minutes < 1) )
                    ? BlinkingAnimation(text: context.l10n.hurry_up)
                    : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    context.l10n.end_in, //'Starts In',
                    style: TextStyle(
                        color: LongaColor.butterscotch,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      finalTimeStr,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                          color: LongaColor.black_four,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            )
            : CircularProgressIndicator(color: LongaColor.marigold,);
  }

  @override
  void dispose() {
    timer.cancel();
    //hurryUpShakeController?.dispose();
    super.dispose();
  }

  void initlizeTimer(DateTime? drawDateTime, DateTime? currentDateTime) {
    try {
      drawDate = drawDateTime!;
      timeDiff = drawDate.difference(currentDateTime!).inSeconds;
      print("gameName ===================>${widget.gameName}");
      print("drawdate ===================>$drawDate");
      print("currentDateTime ===================>$currentDateTime");
      print("-" * 40);
    } catch (e) {
      log("Exception Draw Date time @ initState : $e");
    }
    timer.cancel();
    timer = Timer.periodic(duration, (Timer t) {
      _handleTick();
    });
  }
}
