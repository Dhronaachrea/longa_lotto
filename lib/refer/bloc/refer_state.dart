part of 'refer_bloc.dart';

@immutable
abstract class ReferState {}

class ReferInitial extends ReferState {}

class Inviting extends ReferState {}

class Invited extends ReferState {
  final TrackStatusResponseModel response;

  Invited({required this.response});
}

class InvitationError extends ReferState {
  final String errorMsg;

  InvitationError({required this.errorMsg});
}

class TrackingStatus extends ReferState {}

class TrackedStatus extends ReferState {
  final TrackStatusResponseModel response;

  TrackedStatus({required this.response});
}

class TrackStatusError extends ReferState {
  final String errorMsg;

  TrackStatusError({required this.errorMsg});
}

class SelectStatusState extends ReferState {
  SelectStatusState();
}
