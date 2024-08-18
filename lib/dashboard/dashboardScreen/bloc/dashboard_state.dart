import 'package:longa_lotto/dashboard/dashboardScreen/model/response/check_bonus_status_response.dart';

abstract class DashBoardState {}

class DashBoardInitial extends DashBoardState {}

////////////////////////  Check Bonus Status /////////////////////////

class CheckBonusStatusLoading extends DashBoardState {}

class CheckBonusStatusSuccess extends DashBoardState {
  CheckBonusStatusResponse? response;

  CheckBonusStatusSuccess({required this.response});
}

class CheckBonusStatusError extends DashBoardState {
  String errorMessage;

  CheckBonusStatusError({required this.errorMessage});
}