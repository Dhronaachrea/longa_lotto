import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_event.dart';
import 'package:longa_lotto/myTransaction/bloc/transaction_state.dart';
import 'package:longa_lotto/myTransaction/model/request/TransacrtionRequest.dart';
import 'package:longa_lotto/myTransaction/model/response/transaction_response.dart';
import 'package:longa_lotto/myTransaction/transaction_logic_part/transaction_logic_part.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<GetTransaction>(_onGetTransactionEvent);
  }
}

_onGetTransactionEvent(GetTransaction event, Emitter<TransactionState> emit) async{
  emit(TransactionLoading());

  BuildContext context  = event.context;
  String txnType        = event.txnType;
  int offset            = event.offset;
  String fromDate       = event.fromDate;
  String toDate         = event.toDate;

  var response = await TransactionLogic.callTransactionApi(context,
      TransactionRequest(
          txnType     : txnType,
          fromDate    : fromDate,
          toDate      : toDate,
          offset      : offset.toString(),
          limit       : AppConstants.transactionLimit,
          domainName  : AppConstants.domainName,
          playerToken : UserInfo.userToken,
          playerId    : UserInfo.userId
      ).toJson());


  try {
    response.when(idle: () {

    }, networkFault: (value) {
      emit(TransactionError(errorMessage: context.l10n.not_internet_connection));

    }, responseSuccess: (value) {
      TransactionResponse successResponse =   value as TransactionResponse;
      emit(TransactionSuccess(response: successResponse));

    }, responseFailure: (value) {
      TransactionResponse errorResponse = value as TransactionResponse;
      print("bloc responseFailure: ${errorResponse.errorCode}, ${value.respMsg}");
      emit(TransactionError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.WEAVER, errorResponse.errorCode)));
      //emit(TransactionError(errorMessage: errorResponse.respMsg ?? context.l10n.something_went_wrong_while_extracting_response));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(TransactionError(errorMessage: context.l10n.not_internet_connection));
      } else {
        emit(TransactionError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong));
      }
    });

  } catch(e) {
    print("error=========> $e");
    emit(TransactionError(errorMessage: context.l10n.technical_issue_please_try_again));
  }

}