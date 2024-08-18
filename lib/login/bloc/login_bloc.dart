
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/inbox/logic/inbox_logic.dart';
import 'package:longa_lotto/inbox/model/response/inbox_response.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/login/bloc/login_event.dart';
import 'package:longa_lotto/login/bloc/login_state.dart';
import 'package:longa_lotto/login/login_logic_part/login_logic_part.dart';
import 'package:longa_lotto/login/model/request/LoginRequest.dart';
import 'package:longa_lotto/sign_up/model/response/registration_response.dart';
import 'package:longa_lotto/utils/auth/auth_bloc.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginPlayerEvent>(_onLoginEvent);
    on<GetInbox>(_getInbox);
  }
}

_onLoginEvent(LoginPlayerEvent event, Emitter<LoginState> emit) async{

    BuildContext context      = event.context;
    String userName           = event.userName;
    String password           = encryptMd5(event.password);
    String encryptedPassword  = encryptMd5(password + AppConstants.loginToken);

    var response = await LoginLogic.callLoginApi(context,
        LoginRequest(
          userName: userName,
          password: encryptedPassword,
          deviceType: AppConstants.deviceType,
          domainName: AppConstants.domainName,
          loginDevice: AppConstants.androidLoginDevice,
          loginToken: AppConstants.loginToken,
          requestIp: AppConstants.requestIp,
          trackingCipher: "",
          userAgent: AppConstants.userAgent
        ).toJson());

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(LoginError(errorMessage: context.l10n.not_internet_connection));

      }, responseSuccess: (value) {
        RegistrationResponse successResponse = value as RegistrationResponse;
        BlocProvider.of<AuthBloc>(context).add(
          UserLogin(registrationResponse: successResponse),
        );
        emit(LoginSuccess(response: successResponse));

      }, responseFailure: (value) {
        print("login bloc responseFailure: ${value?.errorCode}, ${value?.errorMessage}");
        emit(LoginError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.RAM, value?.errorCode)));
        //emit(LoginError(errorMessage: value?.errorMessage ?? context.l10n.something_went_wrong_while_extracting_response));

      }, failure: (value) {
        print("login bloc failure: $value");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(LoginError(errorMessage: context.l10n.not_internet_connection));
        } else {
          emit(LoginError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
        }
      });

    } catch(e) {
      print("error=========> $e");
      emit(LoginError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
    }

}

Future<FutureOr<void>> _getInbox(
    GetInbox event, Emitter<LoginState> emit) async {
  Map<String, dynamic> request = {
    "domainName": AppConstants.domainName,
    "limit": LongaConstant.inboxLimit,
    "offset": event.offset,
    "playerId": UserInfo.userId,
    "playerToken": UserInfo.userToken,
  };
  BuildContext context = event.context;
  var response = await InboxLogic.callInbox(
    context,
    request,
  );
  try {
    response.when(
        responseSuccess: (value) {
          InboxResponseModel inboxResponseModel = value as InboxResponseModel;
          UserInfo.setUnReadMsgCount("${inboxResponseModel.unreadMsgCount ?? 0}");
        },
        idle: () {},
        networkFault: (value) {
          // emit(InboxError(value["occurredErrorDescriptionMsg"]));
        },
        responseFailure: (value) {
          print(
              "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
         /* emit(InboxError(value?.respMsg ??
              context.l10n.something_went_wrong_while_extracting_response));*/
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          /*if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
            emit(InboxError(context.l10n.not_internet_connection,));
          } else {
            emit(InboxError(value["occurredErrorDescriptionMsg"] ??
                context.l10n.something_went_wrong));
          }*/
        });
  } catch (e) {
    //emit(InboxError("${context.l10n.technical_issue_please_try_again} $e"));
  }
  // InboxResponseModel? response = await Repository.getInbox(request);
  //  if (response != null) {
  //    if (response.errorCode == 0) {
  //      inboxList = response.plrInboxList!;
  //      emit(InboxLoaded(response.plrInboxList));
  //    } else {
  //      emit(InboxError(response.errorCode,response.respMsg));
  //    }
  //  }
}


