
import 'package:longa_lotto/wallet/deposit/model/response/ConvertToPgCurrencyResponse.dart';
import 'package:longa_lotto/wallet/withdrawal/model/response/WithdrawalRequestResponse.dart';

abstract class WithdrawalState {}

class WithdrawalInitial extends WithdrawalState {}

class WithdrawalLoading extends WithdrawalState {}
class WithdrawalRequestLoading extends WithdrawalState {}

///////////////////////// Payment Option ///////////////////////////

class PaymentOptionsError extends WithdrawalState {
  String? errorMessage;
  int? errorCode;

  PaymentOptionsError({required this.errorMessage, required this.errorCode});
}

class PaymentOptionsSuccess extends WithdrawalState {
  dynamic response;

  PaymentOptionsSuccess({required this.response});
}

////////////////////////// Withdrawal Request ///////////////////////

class WithdrawalRequestError extends WithdrawalState {
  String? errorMessage;
  int? errorCode;

  WithdrawalRequestError({required this.errorMessage, required this.errorCode});
}

class WithdrawalRequestSuccess extends WithdrawalState {
  WithdrawalRequestResponse response;

  WithdrawalRequestSuccess({required this.response});
}

////////////////////////// Scan Withdrawal Request ///////////////////////

class ScanWithdrawalRequestError extends WithdrawalState {
  String? errorMessage;
  int? errorCode;

  ScanWithdrawalRequestError({required this.errorMessage, required this.errorCode});
}

class ScanWithdrawalRequestSuccess extends WithdrawalState {
  WithdrawalRequestResponse response;

  ScanWithdrawalRequestSuccess({required this.response});
}

/////////////////////// currency convertion ///////////////////////////
class ConvertToPgCurrencyError extends WithdrawalState {
  String? errorMessage;
  int? errorCode;

  ConvertToPgCurrencyError({required this.errorMessage, required this.errorCode});
}

class ConvertToPgCurrencySuccess extends WithdrawalState {
  ConvertToPgCurrencyResponse response;

  ConvertToPgCurrencySuccess({required this.response});
}