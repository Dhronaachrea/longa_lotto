import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/changePassword/bloc/change_password_event.dart';
import 'package:longa_lotto/changePassword/bloc/change_password_state.dart';
import 'package:longa_lotto/changePassword/change_password_logic_part/change_password_logic_part.dart';
import 'package:longa_lotto/changePassword/model/request/change_password_request.dart';
import 'package:longa_lotto/changePassword/model/response/change_password_response.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordApiEvent>(_onChangePasswordApiEvent);
  }

  _onChangePasswordApiEvent(ChangePasswordApiEvent event, Emitter<ChangePasswordState> emit) async{
    emit(ChangePasswordLoading());
    BuildContext context  = event.context;
    String oldPassword    = event.oldPassword;
    String newPassword    = event.newPassword;

    var response = await ChangePasswordLogic.callChangePasswordApi(context,
        ChangePasswordRequest(
            oldPassword     : oldPassword,
            newPassword     : newPassword,
            domainName      : AppConstants.domainName,
            playerId        : int.parse(UserInfo.userId),
            playerToken     : UserInfo.userToken
        ).toJson()
    );

    try {
      response.when(idle: () {

      }, networkFault: (value) {

        emit(ChangePasswordError(errorMessage: context.l10n.not_internet_connection));
      }, responseSuccess: (value) {
        ChangePasswordResponse? successResponse = value as ChangePasswordResponse?;
        successResponse?.respMsg = fetchResponseCodeMsg(context, ApiFamily.WEAVER, successResponse.errorCode);
        emit(ChangePasswordSuccess(response: successResponse));

      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
        ChangePasswordResponse? errorResponse = value as ChangePasswordResponse?;
        emit(ChangePasswordError(errorMessage:  fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse?.errorCode)));
        //emit(ChangePasswordError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(ChangePasswordError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(ChangePasswordError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      emit(ChangePasswordError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }
  }

}