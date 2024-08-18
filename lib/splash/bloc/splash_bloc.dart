import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/splash/bloc/splash_event.dart';
import 'package:longa_lotto/splash/bloc/splash_state.dart';
import 'package:longa_lotto/splash/model/request/VersionControlRequest.dart';
import 'package:longa_lotto/splash/model/response/VersionControlResponse.dart';
import 'package:longa_lotto/splash/splash_logic.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<VersionControlApi>(_onVersionControlApi);
  }

  FutureOr<void> _onVersionControlApi(VersionControlApi event, Emitter<SplashState> emit) async {
    emit(VersionControlLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    BuildContext context = event.context;

    var request = VersionControlRequest(
      appType: "Cash",
      currAppVer: packageInfo.version,
      domainName: AppConstants.domainName,
      os: "ANDROID",
      playerToken: UserInfo.userToken,
      playerId: (UserInfo.userId.toString())
    ).toJson();

    var response = await SplashLogic.callVersionControlApi(event.context, request);

    try {
      response.when(
          responseSuccess: (value) {
            print("bloc success");
            VersionControlResponse statusResponseModel = value as VersionControlResponse;
            emit(VersionControlSuccess(response: statusResponseModel));
          },
          idle: () {},
          networkFault: (value) {
            emit(VersionControlError(errorMsg: context.l10n.not_internet_connection));
          },
          responseFailure: (value) {
            print("======================>$value");
            print("splash bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            VersionControlResponse errorResponseModel = value as VersionControlResponse;
            emit(VersionControlError(errorMsg: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponseModel.errorCode)));

            //emit(VersionControlError(errorMsg: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));
          },
          failure: (value) {
            print("splash bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(VersionControlError(errorMsg: context.l10n.not_internet_connection,));
            } else {
              emit(VersionControlError(errorMsg: value["occurredErrorDescriptionMsg"] ?? "Something went wrong "));
            }
          });
    } catch (e) {
      emit(VersionControlError(errorMsg: "Technical issue, Please try again. $e"));
    }
  }

}
