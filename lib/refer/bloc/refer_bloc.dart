import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/model/response/track_status_response.dart';
import 'package:longa_lotto/refer/bloc/logic/refer_logic.dart';
import 'package:longa_lotto/refer/model/friend_contact_model.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

part 'refer_event.dart';

part 'refer_state.dart';

class ReferBloc extends Bloc<ReferEvent, ReferState> {
  ReferBloc() : super(ReferInitial()) {
    on<InviteNow>(_onInviteNow);
    on<TrackStatus>(_onTrackStatus);
    on<SelectStatus>(_onSelectStatus);
  }

  FutureOr<void> _onInviteNow(InviteNow event, Emitter<ReferState> emit) async {
    emit(Inviting());
    var contactDetails = event.contactDetails;
    BuildContext context = event.context;
    List<Map<String, String>> contactDetailsList = contactDetails
        .map((element) => {
              "firstName": element!.name,
              "lastName": "",
              "emailId": element.emailId,
              "mobileNo": ""
            })
        .toList();
    var request = {
      "referalList": contactDetailsList,
      "referType": "mailRefer",
      "inviteMode": "EMAIL",
      "domainName": AppConstants.domainName,
      "deviceType": "ALL",
      "userAgent": AppConstants.userAgent,
      "playerToken": UserInfo.userToken,
      "playerId": UserInfo.userId
    };

    var response = await ReferLogic.callInviteFriendApi(event.context, request);
    try {
      response.when(
          responseSuccess: (value) {
            print("bloc success");
            TrackStatusResponseModel statusResponseModel = value as TrackStatusResponseModel;
            statusResponseModel.respMsg = fetchResponseCodeMsg(context, ApiFamily.WEAVER, statusResponseModel.errorCode);
            emit(
              Invited(response: statusResponseModel),
            );
          },
          idle: () {},
          networkFault: (value) {
            print("network error");
            emit(InvitationError(
                errorMsg: context.l10n.not_internet_connection));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            TrackStatusResponseModel errorResponseModel = value as TrackStatusResponseModel;
            emit(InvitationError(
                errorMsg: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponseModel.errorCode)));

           /* emit(InvitationError(
                errorMsg: value?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(InvitationError(errorMsg: context.l10n.not_internet_connection));
            } else {
              emit(InvitationError(
                  errorMsg: value["occurredErrorDescriptionMsg"] ??
                      "Something went wrong "));
            }
          });
    } catch (e) {
      emit(InvitationError(errorMsg: "${context.l10n.technical_issue_please_try_again} $e"));
    }
  }

  FutureOr<void> _onTrackStatus(
      TrackStatus event, Emitter<ReferState> emit) async {
    emit(TrackingStatus());
    BuildContext context = event.context;
    var request = {
      "domainName": AppConstants.domainName,
      "deviceType": "PC",
      "userAgent": AppConstants.userAgent,
      "playerToken": UserInfo.userToken,
      "playerId": UserInfo.userId
    };
    var response = await ReferLogic.callTrackStatusApi(event.context, request);
    try {
      response.when(
          responseSuccess: (value) {
            print("bloc success");
            TrackStatusResponseModel statusResponseModel =
                value as TrackStatusResponseModel;
            emit(
              TrackedStatus(response: statusResponseModel),
            );
          },
          idle: () {},
          networkFault: (value) {
            print("network error");
            emit(TrackStatusError(
                errorMsg: value["occurredErrorDescriptionMsg"]));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            TrackStatusResponseModel errorResponseModel = value as TrackStatusResponseModel;
            emit(TrackStatusError(
                errorMsg: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponseModel.errorCode)));

            /*emit(TrackStatusError(
                errorMsg: value?.respMsg ??
                    "Something went wrong while extracting response"));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(TrackStatusError(errorMsg: context.l10n.not_internet_connection));
            } else{
              emit(TrackStatusError(
                  errorMsg: value["occurredErrorDescriptionMsg"] ??
                      "Something went wrong "));
            }
          });
    } catch (e) {
      emit(TrackStatusError(errorMsg: "Technical issue, Please try again. $e"));
    }
  }

  FutureOr<void> _onSelectStatus(SelectStatus event, Emitter<ReferState> emit) {
    emit(SelectStatusState());
  }
}
