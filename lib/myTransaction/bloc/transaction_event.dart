import 'package:flutter/cupertino.dart';

abstract class TransactionEvent {}

class GetTransaction extends TransactionEvent {
  BuildContext context;
  String txnType;
  int offset;
  String fromDate;
  String toDate;

  GetTransaction({required this.context, required this.offset, required this.txnType, required this.fromDate, required this.toDate});
}