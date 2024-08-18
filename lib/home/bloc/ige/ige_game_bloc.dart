import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:longa_lotto/home/logic/home_logic.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/model/response/ige_game_response.dart';
import 'package:longa_lotto/utils/utils.dart';

part 'ige_game_event.dart';

part 'ige_game_state.dart';

IgeGameResponse? blocIgeGameResponse;

class IgeGameBloc extends Bloc<IgeGameEvent, IgeGameState> {
  IgeGameBloc() : super(IgeGameInitial()) {
    on<FetchIgeGame>(fetchIgeGame);
  }

  FutureOr<void> fetchIgeGame(event, Emitter<IgeGameState> emit) async {
    emit(FetchingIgeGame());
    BuildContext context = event.context;
    var response = await HomeLogic.callFetchIgeGame(
        context, {"isMobile": true, "service": "B2C"});
    try {
      response.when(
          responseSuccess: (value) {
            IgeGameResponse igeGameResponse = value as IgeGameResponse;
            //ToDo remove below one later
            blocIgeGameResponse = igeGameResponse;
            log("bloc success for ige");
            emit(
              FetchedIgeGame(igeGameResponse: igeGameResponse),
            );
          },
          idle: () {},
          networkFault: (value) {
            log("network error");
            emit(FetchIgeGameError(
                errorMessage: context.l10n.not_internet_connection));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            if (value?.errorCode ==  null) {
              emit(FetchIgeGameError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));
            } else {
              emit(FetchIgeGameError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.IGE, value?.errorCode)));
            }

          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(FetchIgeGameError(errorMessage: context.l10n.not_internet_connection,));
            } else {
              emit(FetchIgeGameError(
                  errorMessage: value["occurredErrorDescriptionMsg"] ??
                      context.l10n.something_went_wrong));
            }
          });
    } catch (e) {
      emit(FetchIgeGameError(
          errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }
  }
}
