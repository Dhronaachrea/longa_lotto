
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/deposit/model/response/GetStatusFromProviderTxnResponse.dart';

abstract class DepositState {}

class DepositInitial extends DepositState {}

class DepositLoading extends DepositState {}

class PaymentOptionsError extends DepositState {
  String? errorMessage;
  int? errorCode;

  PaymentOptionsError({required this.errorMessage, required this.errorCode});
}

class PaymentOptionsSuccess extends DepositState {
  dynamic response;

  PaymentOptionsSuccess({required this.response});
}

class ConvertToPgCurrencyError extends DepositState {
  String? errorMessage;
  int? errorCode;

  ConvertToPgCurrencyError({required this.errorMessage, required this.errorCode});
}

class ConvertToPgCurrencySuccess extends DepositState {
  ConvertToPgCurrencyResponse? response;

  ConvertToPgCurrencySuccess({required this.response});
}

class GetStatusFromProviderTxnError extends DepositState {
  String? errorMessage;
  int? errorCode;

  GetStatusFromProviderTxnError({required this.errorMessage, required this.errorCode});
}

class GetStatusFromProviderTxnSuccess extends DepositState {
  GetStatusFromProviderTxnResponse? response;

  GetStatusFromProviderTxnSuccess({required this.response});
}