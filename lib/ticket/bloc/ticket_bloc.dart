import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:longa_lotto/common/show_snackbar.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/ticket/model/response/tIcket_response.dart';
import 'package:longa_lotto/utils/utils.dart';

import '../../common/constant/date_format.dart';
import '../../common/utils.dart';
import '../../utils/user_info.dart';
import '../model/request/ticket_request.dart';
import '../ticket_logic/ticket_logic.dart';

part 'ticket_event.dart';

part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc() : super(TicketInitial()) {
    on<GetTicket>(_onTicketListResponse);
  }
}

_onTicketListResponse(GetTicket event, Emitter<TicketState> emit) async {
  if (!event.isPagination) {
    emit(TicketLoading());
  }

  BuildContext context = event.context;
  print("date pick =================> ${event.fromDate}");
  var fromDate = formatDate(
    date: event.fromDate,
    inputFormat: Format.rangeDateFormat,
    outputFormat: Format.calendarFormat,
    notTranslate: true
  );

  var toDate = formatDate(
    date: event.toDate,
    inputFormat: Format.rangeDateFormat,
    outputFormat: Format.calendarFormat,
    notTranslate: true
  );

  var response = await TicketLogic.getTicketList(
      context,
      TicketRequest(
              domainName: "www.longagames.com",
              fromDate: fromDate,
              limit: event.limit.toString(),
              offset: event.offset.toString(),
              playerId: UserInfo.userId,
              playerToken: UserInfo.userToken,
              toDate: toDate,
              txnType: "ALL",
              orderBy: "DESC"
      )
          .toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          ShowToast.showToast(context, context.l10n.not_internet_connection, type: ToastType.ERROR);
          emit(TicketLoadingError(errorMessage: context.l10n.not_internet_connection));
        },
        responseSuccess: (value) {
          emit(TicketLoaded(ticketList: (value as TicketResponse).ticketList));
          print("bloc success");
        },
        responseFailure: (value) {

          print("bloc responseFailure: ${value}");
          TicketResponse? errorResponse = value as TicketResponse?;
          // no error msg given in response
          emit(TicketLoadingError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse?.errorCode)));

          //emit(TicketLoadingError(errorMessage: errorResponse?.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
            emit(TicketLoadingError(errorMessage: context.l10n.not_internet_connection,));
          } else {
            emit(TicketLoadingError(
                errorMessage: value["occurredErrorDescriptionMsg"] ??

                    context.l10n.something_went_wrong));
          }
        });
  } catch (e) {
    emit(TicketLoadingError(
        errorMessage: "${context.l10n.technical_issue_please_try_again} $e"));
  }
}
