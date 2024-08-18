import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_event.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/bloc/dashboard_state.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/dashboard_logic_part/dashboard_logic_part.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/model/request/check_bonus_status_player_request.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/model/response/check_bonus_status_response.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/utils.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitial()) {
    on<CheckBonusStatusEvent>(_onCheckBonusStatusEvent);
  }
}

_onCheckBonusStatusEvent(CheckBonusStatusEvent event, Emitter<DashBoardState> emit) async{
    BuildContext context                    = event.context;
    CheckBonusStatusPlayerRequest request   = event.request;

    var response = await DashBoardLogic.callCheckBonusStatusPlayerApi(context, request.toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(CheckBonusStatusError(errorMessage: context.l10n.not_internet_connection));

      }, responseSuccess: (value) {
        CheckBonusStatusResponse successResponse = value as CheckBonusStatusResponse;
        successResponse.errorMessage = fetchResponseCodeMsg(context, ApiFamily.BONUS, successResponse.errorCode);
        emit(CheckBonusStatusSuccess(response: successResponse));

      }, responseFailure: (value) {
        RegistrationResponse? errorResponse = value as RegistrationResponse?;
        print("dashboard bloc responseFailure: ${errorResponse?.errorCode}, ${errorResponse?.errorMessage}");
        emit(CheckBonusStatusError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.BONUS, errorResponse?.errorCode)));
        //emit(CheckBonusStatusError(errorMessage: errorResponse?.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("dashboard bloc failure: ${value["occurredErrorDescriptionMsg"]}");

        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(CheckBonusStatusError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(CheckBonusStatusError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });
    } catch(e) {
      print("error=========> $e");
      emit(CheckBonusStatusError(errorMessage: "Technical issue, Please try again. $e"));
    }

}


