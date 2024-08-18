import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/common/constant/longa_constant.dart';
import 'package:longa_lotto/inbox/logic/inbox_logic.dart';
import 'package:longa_lotto/inbox/model/response/inbox_response.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

part 'inbox_event.dart';

part 'inbox_state.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  InboxBloc() : super(InboxInitial()) {
    on<GetInbox>(_getInbox);
    on<InboxActivity>(_inboxActivity);
    on<InboxActivityMarkRead>(_inboxActivityMarkRead);
    on<InboxSearch>(_inboxSearch);
  }

  List<PlrInboxList> inboxList = [];
  List<PlrInboxList> searchList = [];

  Future<FutureOr<void>> _getInbox(GetInbox event, Emitter<InboxState> emit) async {
    emit(InboxLoading());
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
            emit(InboxLoaded(inboxResponseModel.plrInboxList));
          },
          idle: () {},
          networkFault: (value) {
            emit(InboxError(value["occurredErrorDescriptionMsg"]));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            emit(InboxError(fetchResponseCodeMsg(context, ApiFamily.WEAVER, value?.errorCode)));
            /*emit(InboxError(value?.respMsg ??
                context.l10n.something_went_wrong_while_extracting_response));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(InboxError(context.l10n.not_internet_connection,));
            } else {
              emit(InboxError(value["occurredErrorDescriptionMsg"] ??
                  context.l10n.something_went_wrong));
            }
          });
    } catch (e) {
      emit(InboxError("${context.l10n.technical_issue_please_try_again} $e"));
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

  Future<FutureOr<void>> _inboxActivity(InboxActivity event, Emitter<InboxState> emit) async {
    var activity = event.activity;
    var inboxId = event.inboxId;

    emit(InboxLoading());
    Map<String, dynamic> request = {
      "activity": activity,
      "domainName": AppConstants.domainName,
      "inboxIdList": [inboxId],
      "limit": LongaConstant.inboxLimit,
      "offset": LongaConstant.inboxOffset,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };
    BuildContext context = event.context;
    var response = await InboxLogic.callInboxActivity(
      context,
      request,
    );
    try {
      response.when(
          responseSuccess: (value) {
            InboxResponseModel inboxResponseModel = value as InboxResponseModel;
            UserInfo.setUnReadMsgCount("${inboxResponseModel.unreadMsgCount ?? 0}");
            emit(InboxDeleteLoaded());
            emit(InboxLoaded(inboxResponseModel.plrInboxList));
          },
          idle: () {},
          networkFault: (value) {
            emit(InboxError(value["occurredErrorDescriptionMsg"]));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            emit(InboxError(fetchResponseCodeMsg(context, ApiFamily.WEAVER, value?.errorCode)));
            /*emit(InboxError(value?.respMsg ??
                context.l10n.something_went_wrong_while_extracting_response));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(InboxError(context.l10n.not_internet_connection,));
            } else {
              emit(InboxError(value["occurredErrorDescriptionMsg"] ??
                  context.l10n.something_went_wrong));
            }
          });
    } catch (e) {
      emit(InboxError("${context.l10n.technical_issue_please_try_again} $e"));
    }
    // InboxResponseModel? response = await Repository.inboxActivity(request);
    //  if (response != null) {
    //    if (response.errorCode == 0) {
    //      //inboxList = response.plrInboxList!;
    //      emit(InboxDeleteLoaded());
    //      emit(InboxLoaded(response.plrInboxList));
    //    } else {
    //      emit(InboxError(response.errorCode,response.respMsg));
    //    }
    //  }
  }

  Future<FutureOr<void>> _inboxActivityMarkRead(InboxActivityMarkRead event, Emitter<InboxState> emit) async {
    var activity = event.activity;
    var inboxId = event.inboxId;

    emit(InboxLoading());
    Map<String, dynamic> request = {
      "activity": activity,
      "domainName": AppConstants.domainName,
      "inboxId": inboxId,
      "playerId": UserInfo.userId,
      "playerToken": UserInfo.userToken,
    };


    BuildContext context = event.context;
    var response = await InboxLogic.callInboxActivity(
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
            emit(InboxError(value["occurredErrorDescriptionMsg"]));
          },
          responseFailure: (value) {
            print(
                "bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
            emit(InboxError(fetchResponseCodeMsg(context, ApiFamily.WEAVER, value?.errorCode)));
            /*emit(InboxError(value?.respMsg ??
                context.l10n.something_went_wrong_while_extracting_response));*/
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
              emit(InboxError(context.l10n.not_internet_connection,));
            } else {
              emit(InboxError(value["occurredErrorDescriptionMsg"] ??
                  context.l10n.something_went_wrong));
            }
          });
    } catch (e) {
      emit(InboxError("${context.l10n.technical_issue_please_try_again} $e"));
    }
  }

  FutureOr<void> _inboxSearch(InboxSearch event, Emitter<InboxState> emit) {
    var query = event.query;
    var actualInboxList = event.inboxList;

    if (query.isNotEmpty) {
      List<PlrInboxList> tempInboxList = [];
      for (PlrInboxList plrInboxList in actualInboxList) {
        if (plrInboxList.subject!.contains(query) ||
            plrInboxList.subject!.contains(query.toLowerCase()) ||
            plrInboxList.subject!.contains(query.toUpperCase())) {
          tempInboxList.add(plrInboxList);
        }
      }
      if (tempInboxList.isNotEmpty) {
        searchList = tempInboxList;
      } else {
        searchList.clear();
      }
    } else {
      searchList.clear();
    }
    emit(InboxSearchLoaded(searchList));
  }
}
