part of 'refer_bloc.dart';

@immutable
abstract class ReferEvent {}

class InviteNow extends ReferEvent {
  final BuildContext context;
  final List<FriendContactModel?> contactDetails;

  InviteNow({required this.context, required this.contactDetails});
}

class TrackStatus extends ReferEvent {
  final BuildContext context;

  TrackStatus({required this.context});
}

class SelectStatus extends ReferEvent {
  final BuildContext context;

  SelectStatus({required this.context});
}
