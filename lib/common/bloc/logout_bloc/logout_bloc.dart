import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_event.dart';
import 'package:longa_lotto/common/bloc/logout_bloc/logout_state.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/logic/utils_logic.dart';
import 'package:longa_lotto/common/model/request/logout_request.dart';
import 'package:longa_lotto/common/model/response/logout_response.dart';
import 'package:longa_lotto/common/navigation/longa_screen.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/common/utils.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutApiEvent>(_onLogoutApiEvent);
  }

  _onLogoutApiEvent(LogoutApiEvent event, Emitter<LogoutState> emit) async{
    emit(LogoutLoading());
    BuildContext context = event.context;

    var response = await UtilsLogic.callLogoutApi(context,
        LogoutRequest(
            domainName  : AppConstants.domainName,
            playerId    : int.parse(UserInfo.userId),
            playerToken : UserInfo.userToken
        ).toJson()
    );

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(LogoutError(errorMessage: context.l10n.not_internet_connection));
      }, responseSuccess: (value) {
        LogoutResponse successResponse = value as LogoutResponse;
        if (navigatorKey.currentContext != null) {
          BlocProvider.of<AuthBloc>(navigatorKey.currentContext!).add(UserLogout());
          ShowToast.showToast(navigatorKey.currentContext!, context.l10n.successfully_logout, type: ToastType.SUCCESS);
          Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(LongaScreen.homeScreen, (route) => false);
        } else {
          print("navigatorKey.currentContext: ${navigatorKey.currentContext}");
        }
        successResponse.respMsg = fetchResponseCodeMsg(context, ApiFamily.WEAVER, successResponse.errorCode);
        emit(LogoutSuccess(response: successResponse));

      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
        LogoutResponse errorResponse = value as LogoutResponse;
        emit(LogoutError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
        //emit(LogoutError(errorMessage: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("logout bloc failure: $value");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(LogoutError(errorMessage: context.l10n.not_internet_connection,));
        } else {
          emit(LogoutError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }

      });

    } catch(e) {
      emit(LogoutError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

  }

}