import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/home/logic/home_logic.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/model/response/dge_game_response.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

part 'dge_game_event.dart';

part 'dge_game_state.dart';

DgeGameResponse? blocDgeGameResponse;

class DgeGameBloc extends Bloc<DgeGameEvent, DgeGameState> {
  DgeGameBloc() : super(DgeGameInitial()) {
    on<FetchDgeGame>(fetchDgeGame);
  }

  FutureOr<void> fetchDgeGame(
      FetchDgeGame event, Emitter<DgeGameState> emit) async {
    emit(FetchingDgeGame());
    BuildContext context = event.context;
    var response = await HomeLogic.callFetchDgeGame(
      context,
      {
        "domainCode": AppConstants.domainName,
        "field": ["BET_INFO", "DRAW_INFO"],
        "gameCodes": ["DailyLotto2","EightByTwentyFour"],//FiveByFortyNineLottoWeekly
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
            // if(value is DgeGameResponse){
            //   log("value is DgeGameResponse type");
            // } else{
            //   log("value is not DgeGameResponse type: ${value.runtimeType}");
            // }
            DgeGameResponse dgeGameResponse = value as DgeGameResponse;
            blocDgeGameResponse = dgeGameResponse;
            dgeGameResponse.responseMessage = fetchResponseCodeMsg(context, ApiFamily.DGE, dgeGameResponse.responseCode);
            emit(
              FetchedDgeGame(dgeGameResponse: dgeGameResponse),
            );
          },
          idle: () {},
          networkFault: (value) {
            log("network error");
            emit(FetchDgeGameError(
                errorMessage: context.l10n.not_internet_connection));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            DgeGameResponse errorResponse = value as DgeGameResponse;
            emit(FetchDgeGameError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.DGE, errorResponse.responseCode)));
            /*emit(FetchDgeGameError(
                errorMessage: value?.respMsg ??
                    context
                        .l10n.something_went_wrong_while_extracting_response));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(FetchDgeGameError(errorMessage: context.l10n.not_internet_connection,));
            } else {
              emit(FetchDgeGameError(
                  errorMessage: value["occurredErrorDescriptionMsg"] ??
                      context.l10n.something_went_wrong));
            }
          });
    } catch (e) {
      emit(FetchDgeGameError(
          errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }
  }
}
