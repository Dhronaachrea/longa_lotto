import 'package:flutter/widgets.dart';

abstract class WithdrawalEvent {}

class PaymentOptionsApiEvent extends WithdrawalEvent {
  BuildContext context;

  PaymentOptionsApiEvent({required this.context});
}

class WithdrawalRequestApiEvent extends WithdrawalEvent {
  BuildContext context;
  String amount;
  String pgCurrencyCode;
  int paymentTypeId;
  int subTypeId;
  String accNum;

  WithdrawalRequestApiEvent({
    required this.context,
    required this.amount,
    required this.pgCurrencyCode,
    required this.paymentTypeId,
    required this.subTypeId,
    required this.accNum,
  });
}

class ScanWithdrawalInitiateRequestApiEvent extends WithdrawalEvent {
  BuildContext context;
  String amount;
  String pgCurrencyCode;
  int paymentTypeId;
  int subTypeId;
  String accNum;

  ScanWithdrawalInitiateRequestApiEvent({
    required this.context,
    required this.amount,
    required this.pgCurrencyCode,
    required this.paymentTypeId,
    required this.subTypeId,
    required this.accNum,
  });
}

class ConvertToPgCurrencyApiEvent extends WithdrawalEvent {
  BuildContext context;
  String reqAmtCurrencyCode;
  int amount;
  int paymentTypeId;
  int subTypeId;

  ConvertToPgCurrencyApiEvent({
    required this.context,
    required this.amount,
    required this.reqAmtCurrencyCode,
    required this.paymentTypeId,
    required this.subTypeId,
  });
}

