import 'package:flutter/widgets.dart';

abstract class DepositEvent {}

class PaymentOptionsApiEvent extends DepositEvent {
  BuildContext context;

  PaymentOptionsApiEvent({required this.context});
}

class ConvertToPgCurrencyApiEvent extends DepositEvent {
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

class GetStatusFromProviderApiEvent extends DepositEvent {
  BuildContext context;
  int txnId;

  GetStatusFromProviderApiEvent({required this.context, required this.txnId});
}

