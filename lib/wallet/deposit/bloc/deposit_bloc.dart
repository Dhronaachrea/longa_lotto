import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_event.dart';
import 'package:longa_lotto/wallet/deposit/bloc/deposit_state.dart';
import 'package:longa_lotto/wallet/deposit/deposit_logic_part.dart';
import 'package:longa_lotto/wallet/deposit/model/request/ConvertToPgCurrencyRequest.dart';
import 'package:longa_lotto/wallet/deposit/model/request/GetStatusFromProviderTxnRequest.dart';
import 'package:longa_lotto/wallet/deposit/model/request/PaymentOptionsRequest.dart';
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/deposit/model/response/GetStatusFromProviderTxnResponse.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  DepositBloc() : super(DepositInitial()) {
    on<PaymentOptionsApiEvent>(_onDepositApiEvent);
    on<ConvertToPgCurrencyApiEvent>(_onConvertToPgCurrencyApiEvent);
    on<GetStatusFromProviderApiEvent>(_getStatusFromProviderApiEvent);
  }

  _onDepositApiEvent(PaymentOptionsApiEvent event, Emitter<DepositState> emit) async{
    emit(DepositLoading());
    BuildContext context = event.context;

    var response = await DepositLogic.callPaymentOptionsApi(context,
        PaymentOptionsRequest(
            deviceType: "MOBILE",
            domainName: AppConstants.domainName,
            playerId:   int.parse(UserInfo.userId),
            txnType: "DEPOSIT",
            userAgent: "Dalvik/2.1.0 (Linux; U; Android 12; sdk_gphone64_arm64 Build/SPB5.210812.003)"
        ).toJson()
    );

    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(PaymentOptionsError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

      }, responseSuccess: (value) {
        emit(PaymentOptionsSuccess(response: value));
      }, responseFailure: (value) {
        print("deposit failure---->$value");
        // {errorCode: 308, errorMsg: No payment options available.}
        print("bloc responseFailure: ${value["errorCode"]}, ${value["errorMsg"]}");
        emit(PaymentOptionsError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, value["errorCode"]), errorCode: value["errorCode"]));
        //emit(PaymentOptionsError(errorMessage: value["errorMsg"] ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value["errorCode"]));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(PaymentOptionsError(errorMessage: context.l10n.not_internet_connection, errorCode: value["errorCode"]));
        } else {
          emit(PaymentOptionsError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value["errorCode"]));
        }
      });

    } catch(e) {
      print("error------->");
      emit(PaymentOptionsError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }

  }

  _onConvertToPgCurrencyApiEvent(ConvertToPgCurrencyApiEvent event, Emitter<DepositState> emit) async{
    emit(DepositLoading());
    BuildContext context = event.context;

    var response = await DepositLogic.callConvertToPgCurrencyApi(context,
        ConvertToPgCurrencyRequest(
          amount: event.amount,
          reqAmtCurrencyCode: event.reqAmtCurrencyCode,
          pgCurrencyCode: event.reqAmtCurrencyCode,
          aliasName: AppConstants.domainName,
          exchangeType: "DEPOSIT",
          paymentTypeId: event.paymentTypeId,
          subTypeId: event.subTypeId,
          device: AppConstants.deviceType
        ).toJson()
    );


    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(ConvertToPgCurrencyError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

      }, responseSuccess: (value) {
        ConvertToPgCurrencyResponse? successResponse = value as ConvertToPgCurrencyResponse?;
        emit(ConvertToPgCurrencySuccess(response: successResponse));
      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.errorMsg}");
        emit(ConvertToPgCurrencyError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, value?.errorCode), errorCode: value?.errorCode));

        //emit(ConvertToPgCurrencyError(errorMessage: value?.errorMsg ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value?.errorCode));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(ConvertToPgCurrencyError(errorMessage: context.l10n.not_internet_connection, errorCode: value?.errorCode));
        } else {
          emit(ConvertToPgCurrencyError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value?.errorCode));
        }
      });

    } catch(e) {
      print("error------->");
      emit(ConvertToPgCurrencyError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }

  }

  _getStatusFromProviderApiEvent(GetStatusFromProviderApiEvent event, Emitter<DepositState> emit) async{
    emit(DepositLoading());
    BuildContext context = event.context;

    var response = await DepositLogic.callGetStatusFromProviderTxnApi(context,
        GetStatusFromProviderTxnRequest(
            domainName: AppConstants.domainName,
            merchantCode: AppConstants.merchantCode,
            playerId: int.parse(UserInfo.userId),
            txnId: event.txnId
        ).toJson()
    );


    try {
      response.when(idle: () {

      }, networkFault: (value) {
        emit(GetStatusFromProviderTxnError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

      }, responseSuccess: (value) {
        GetStatusFromProviderTxnResponse? successResponse = value as GetStatusFromProviderTxnResponse?;
        emit(GetStatusFromProviderTxnSuccess(response: successResponse));
      }, responseFailure: (value) {
        print("bloc responseFailure: ${value?.errorCode}, ${value?.errorMsg}");
        emit(GetStatusFromProviderTxnError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, value?.errorCode), errorCode: value?.errorCode));

        //emit(ConvertToPgCurrencyError(errorMessage: value?.errorMsg ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value?.errorCode));

      }, failure: (value) {
        print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
          emit(GetStatusFromProviderTxnError(errorMessage: context.l10n.not_internet_connection, errorCode: value?.errorCode));
        } else {
          emit(GetStatusFromProviderTxnError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value?.errorCode));
        }
      });

    } catch(e) {
      print("error------->");
      emit(GetStatusFromProviderTxnError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }
  }

}