import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:longa_lotto/common/constant/api_constant.dart';
import 'package:longa_lotto/l10n/l10n.dart';
import 'package:longa_lotto/utils/user_info.dart';
import 'package:longa_lotto/utils/utils.dart';
import 'package:longa_lotto/wallet/deposit/model/request/ConvertToPgCurrencyRequest.dart';
import 'package:longa_lotto/wallet/deposit/model/request/PaymentOptionsRequest.dart';
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/withdrawal_event.dart';
import 'package:longa_lotto/wallet/withdrawal/bloc/withdrawal_state.dart';
import 'package:longa_lotto/wallet/withdrawal/model/request/ScanWithdrawalRequest.dart';
import 'package:longa_lotto/wallet/withdrawal/model/request/withdrawalRequest.dart';
import 'package:longa_lotto/wallet/withdrawal/withdrawal_logic_part.dart';

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  WithdrawalBloc() : super(WithdrawalInitial()) {
    on<PaymentOptionsApiEvent>(_onWithdrawalPaymentOptionApiEvent);
    on<WithdrawalRequestApiEvent>(_onWithdrawalRequestApiEvent);
    on<ScanWithdrawalInitiateRequestApiEvent>(_onScanWithdrawalInitiateRequestApiEvent);
    on<ConvertToPgCurrencyApiEvent>(_onConvertToPgCurrencyApiEvent);
  }

  _onWithdrawalPaymentOptionApiEvent(PaymentOptionsApiEvent event, Emitter<WithdrawalState> emit) async{
    emit(WithdrawalLoading());
    BuildContext context = event.context;

    var response = await WithdrawalLogic.callPaymentOptionsApi(context,
        PaymentOptionsRequest(
            deviceType: AppConstants.deviceType,
            domainName: UserInfo.getAliasNameScan.contains("scan") ? "www.scanplay-longagames.com" : AppConstants.domainName,
            playerId:   int.parse(UserInfo.userId),
            txnType: "WITHDRAWAL",
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
        print("withdrawal failure---->$value");
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

  _onWithdrawalRequestApiEvent(WithdrawalRequestApiEvent event, Emitter<WithdrawalState> emit) async{
    emit(WithdrawalRequestLoading());
    BuildContext context = event.context;
    var response = await WithdrawalLogic.callWithdrawalRequestApi(context,
        WithdrawalRequest(
          amount: double.parse(event.amount),
          currencyCode: event.pgCurrencyCode,
          pgCurrencyCode: event.pgCurrencyCode,
          deviceType: AppConstants.deviceType,
          domainName: AppConstants.domainName,
          merchantCode: AppConstants.merchantCode,
          paymentTypeId: event.paymentTypeId,
          playerId: int.parse(UserInfo.userId),
          playerToken: UserInfo.userToken,
          subTypeId: event.subTypeId,
          txnType: "WITHDRAWAL",
          accNum: event.accNum
        ).toJson()
    );


    response.when(idle: () {

    }, networkFault: (value) {
      emit(WithdrawalRequestError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

    }, responseSuccess: (value) {
      emit(WithdrawalRequestSuccess(response: value));
    }, responseFailure: (value) {
      print("bloc responseFailure: $value");
      emit(WithdrawalRequestError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, value?.errorCode), errorCode: value?.errorCode));

      //emit(WithdrawalRequestError(errorMessage: value?.errorMsg.toString() ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value?.errorCode));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(WithdrawalRequestError(errorMessage: context.l10n.not_internet_connection, errorCode: value["errorCode"]));
      } else {
        emit(WithdrawalRequestError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value["errorCode"]));
      }
    });

    try {

    } catch(e) {
      print("error------->");
      emit(WithdrawalRequestError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }

  }

  _onScanWithdrawalInitiateRequestApiEvent(ScanWithdrawalInitiateRequestApiEvent event, Emitter<WithdrawalState> emit) async{
    emit(WithdrawalRequestLoading());
    BuildContext context = event.context;
    var response = await WithdrawalLogic.callWithdrawalRequestApi(context,
        ScanWithdrawalRequest(
            amount: event.amount,
            currencyCode: event.pgCurrencyCode,
            pgCurrencyCode: event.pgCurrencyCode,
            deviceType: AppConstants.deviceType,
            domainName: "www.scanplay-longagames.com",
            merchantCode: AppConstants.merchantCode,
            paymentTypeId: event.paymentTypeId.toString(),
            playerId: int.parse(UserInfo.userId),
            playerToken: UserInfo.userToken,
            subTypeId: event.subTypeId.toString(),
            txnType: "WITHDRAWAL",
            description: "withdrawal test",
            userAgent: "Mozilla\/5.0 (X11; Linux x86_64) AppleWebKit\/537.36 (KHTML, like Gecko) Chrome\/107.0.0.0 Safari\/537.36",
        ).toJson()
    );

    response.when(idle: () {

    }, networkFault: (value) {
      emit(ScanWithdrawalRequestError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

    }, responseSuccess: (value) {
      emit(ScanWithdrawalRequestSuccess(response: value));
    }, responseFailure: (value) {
      print("bloc responseFailure: $value");
      emit(ScanWithdrawalRequestError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, value?.errorCode), errorCode: value?.errorCode));

      //emit(WithdrawalRequestError(errorMessage: value?.errorMsg.toString() ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value?.errorCode));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(ScanWithdrawalRequestError(errorMessage: context.l10n.not_internet_connection, errorCode: value["errorCode"]));
      } else {
        emit(ScanWithdrawalRequestError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value["errorCode"]));
      }
    });

    try {

    } catch(e) {
      print("error------->");
      emit(ScanWithdrawalRequestError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }

  }

  _onConvertToPgCurrencyApiEvent(ConvertToPgCurrencyApiEvent event, Emitter<WithdrawalState> emit) async{
    emit(WithdrawalLoading());
    BuildContext context = event.context;

    var response = await WithdrawalLogic.callConvertToPgCurrencyApi(context,
        ConvertToPgCurrencyRequest(
            amount: event.amount,
            reqAmtCurrencyCode: event.reqAmtCurrencyCode,
            pgCurrencyCode: event.reqAmtCurrencyCode,
            aliasName: AppConstants.domainName,
            exchangeType: "WITHDRAWAL",
            paymentTypeId: event.paymentTypeId,
            subTypeId: event.subTypeId,
            device: AppConstants.deviceType
        ).toJson()
    );

    response.when(idle: () {

    }, networkFault: (value) {
      emit(ConvertToPgCurrencyError(errorMessage: context.l10n.not_internet_connection, errorCode: -1));

    }, responseSuccess: (value) {
      ConvertToPgCurrencyResponse successResponse = value as ConvertToPgCurrencyResponse;
      emit(ConvertToPgCurrencySuccess(response: successResponse));
    }, responseFailure: (value) {
      print("bloc responseFailure: ${value?.errorCode}, ${value?.errorMsg}");
      ConvertToPgCurrencyResponse errorResponse = value as ConvertToPgCurrencyResponse;
      emit(ConvertToPgCurrencyError(errorMessage: fetchResponseCodeMsg(context, ApiFamily.CASHIER, errorResponse.errorCode), errorCode: errorResponse.errorCode));

      //emit(ConvertToPgCurrencyError(errorMessage: value?.errorMsg ?? context.l10n.something_went_wrong_while_extracting_response, errorCode: value["errorCode"]));

    }, failure: (value) {
      print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
      if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
        emit(ConvertToPgCurrencyError(errorMessage: context.l10n.not_internet_connection, errorCode: value["errorCode"]));
      } else {
        emit(ConvertToPgCurrencyError(errorMessage: value["occurredErrorDescriptionMsg"] ?? context.l10n.something_went_wrong, errorCode: value["errorCode"]));
      }
    });

    try {


    } catch(e) {
      print("error------->");
      emit(ConvertToPgCurrencyError(errorMessage: "${context.l10n.technical_issue_please_try_again} $e", errorCode: -1));
    }

  }

}