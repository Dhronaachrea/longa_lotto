import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_state.dart';
import 'package:longa_lotto/forgotPassword/bloc/forgot_password_event.dart';
import 'package:longa_lotto/forgotPassword/forgot_password_logic_part/forgot_password_logic_part.dart';
import 'package:longa_lotto/forgotPassword/model/request/forgot_password_request.dart';
import 'package:longa_lotto/forgotPassword/model/request/reset_password_request.dart';
import 'package:longa_lotto/forgotPassword/model/response/forgot_password_response.dart';
import 'package:longa_lotto/forgotPassword/model/response/reset_password_response.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/utils.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordApiEvent>(_onForgotPasswordApiEvent);
    on<ResetPasswordApiEvent>(_onRestPasswordApiEvent);
  }

  _onForgotPasswordApiEvent(ForgotPasswordApiEvent event, Emitter<ForgotPasswordState> emit) async{
    emit(ForgotPasswordLoading());
    String mobileNumber  = event.mobileNo;
    BuildContext context = event.context;

    var response = await ForgotPasswordLogic.callForgotPasswordApi(context,
        ForgotPasswordRequest(
            mobileNo    : mobileNumber,
            domainName  : AppConstants.domainName
        ).toJson()
    );

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(ForgotPasswordError(errorMessage: context.l10n.not_internet_connection));

      }, responseSuccess: (value) {
        ForgotPasswordResponse successResponse = value as ForgotPasswordResponse;
        successResponse.respMsg = fetchResponseCodeMsg(context, ApiFamily.WEAVER, successResponse.errorCode);
        emit(ForgotPasswordSuccess(response: successResponse));
      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
        ForgotPasswordResponse errorResponse = value as ForgotPasswordResponse;
        emit(ForgotPasswordError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
        //emit(ForgotPasswordError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("SocketException")) {
          emit(ForgotPasswordError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(ForgotPasswordError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      emit(ForgotPasswordError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

  }

  _onRestPasswordApiEvent(ResetPasswordApiEvent event, Emitter<ForgotPasswordState> emit) async{
    emit(ForgotPasswordLoading());
    ResetPasswordRequest request  = event.request;
    BuildContext context          = event.context;

    var response = await ForgotPasswordLogic.callResetPasswordApi(context, request.toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(ResetPasswordError(errorMessage: value["occurredErrorDescriptionMsg"]));

      }, responseSuccess: (value) {
        ResetPasswordResponse successResponse = value as ResetPasswordResponse;
        successResponse.respMsg = fetchResponseCodeMsg(context, ApiFamily.WEAVER, successResponse.errorCode);
        emit(ResetPasswordSuccess(response: successResponse));

      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
        ResetPasswordResponse errorResponse = value as ResetPasswordResponse;
        emit(ResetPasswordError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
        //emit(ResetPasswordError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(ForgotPasswordError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(ResetPasswordError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }

      });

    } catch(e) {
      emit(ForgotPasswordError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

  }
}