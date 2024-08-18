import 'package:longa_lotto/myTransaction/model/response/transaction_response.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState{}

class TransactionSuccess extends TransactionState{
  TransactionResponse? response;

  TransactionSuccess({required this.response});

}
class TransactionError extends TransactionState{
  String errorMessage;

  TransactionError({required this.errorMessage});
}

