

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/longa_color.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_bloc.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_event.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_state.dart';
import 'package:velocity_x/velocity_x.dart';

class StatusTimerDialog extends StatefulWidget {
  Function callback;
  StatusTimerDialog({super.key, required this.callback});

  @override
  State<StatusTimerDialog> createState() => _StatusTimerDialogState();
}

class _StatusTimerDialogState extends State<StatusTimerDialog> {


  int currentSeconds                    = 0;
  static const interval                 = Duration(seconds: 1);
  Timer timer                           = Timer(interval, () {});
  final int timerMaxSeconds             = 90;
  bool showTimer                        = false;
  late BuildContext myContext;

  @override
  initState() {
    startTimeout(interval);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DepositBloc> (
          create: (BuildContext blocContext) => DepositBloc(),
        )
      ],
      child: StatefulBuilder(
        builder: (BuildContext buildCtx, StateSetter setState){
          return BlocListener<DepositBloc, DepositState> (
            listener: (context, state) {
              setState((){

                if(state is GetStatusFromProviderTxnSuccess) {

                  if((state.response?.status ?? "").toLowerCase() == 'success') {
                    fetchHeaderInfo(context);
                    Navigator.pop(context);
                  } else if ((state.response?.status ?? "").toLowerCase().contains("fail")) {
                    Navigator.pop(context);
                    ShowToast.showToast(context, context.l10n.deposit_failed, type: ToastType.ERROR);
                  }

                } else if (state is GetStatusFromProviderTxnError) {
                  //Navigator.pop(context);
                }

              });
            },
            child: Dialog(
              elevation: 5.0,
              insetPadding: EdgeInsets.symmetric(horizontal: isMobileDevice() ? 32.0 : 74.0, vertical: 24.0),
              backgroundColor: LongaColor.white_five,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeightBox(20),
                  RichText(
                      text: TextSpan(
                        text: context.l10n.request_sent_please_check,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: LongaColor.black_two,
                        ),
                        children: [
                          TextSpan(
                              text: timerText + " ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: LongaColor.reddish_pink
                            )
                          ),
                          TextSpan(
                            text: context.l10n.seconds_remaining,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: LongaColor.black_two
                            )
                          )
                        ]
                      ),
                      textAlign: TextAlign.center,
                  ).pSymmetric(h:20, v:10),


                  /*HeightBox(30),
                  Center(
                      child: Text(
                        timerText,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: LongaColor.black_5
                        ),
                      )
                  ),*/

                  HeightBox(20),
                  InkWell(
                    onTap:() {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)

                      ),
                      child: Center(
                          child: Text(
                              context.l10n.close,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                fontWeight: FontWeight.w500
                              ),
                            ).p(10)
                      ),
                    ).p(10),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  startTimeout(Duration duration) {
    if (!mounted) return;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds){

          timer.cancel();
        }
      });
      if (timer.tick == 30 || timer.tick == 60 || timer.tick == 80) {
        print("==========> ${timer.tick}");
        widget.callback();

      } else if (timer.tick == 90) {
        fetchHeaderInfo(context);
        Navigator.pop(context);
      }
    });
  }

  String get timerText {
    if (currentSeconds == 0) {
      return '';
    } else {
      return  ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0');
    }
  }

}
