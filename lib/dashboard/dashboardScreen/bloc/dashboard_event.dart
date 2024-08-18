import 'package:flutter/widgets.dart';
import 'package:longa_lotto/dashboard/dashboardScreen/model/request/check_bonus_status_player_request.dart';

abstract class DashBoardEvent {}

class CheckBonusStatusEvent extends DashBoardEvent {
  BuildContext context;
  CheckBonusStatusPlayerRequest request;

  CheckBonusStatusEvent({required this.context, required this.request});
}