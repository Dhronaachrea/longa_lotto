part of 'inbox_bloc.dart';

@immutable
abstract class InboxState {}

class InboxInitial extends InboxState {}

class InboxLoading extends InboxState {}

class InboxLoaded extends InboxState {
  final List<PlrInboxList>? inboxResponseList;

  InboxLoaded(this.inboxResponseList);
}

class InboxSearchLoaded extends InboxState {
  final List<PlrInboxList>? inboxResponseList;

  InboxSearchLoaded(this.inboxResponseList);
}

class InboxDeleteLoaded extends InboxState {}

class InboxError extends InboxState {
  final String? errorMsg;

  InboxError(this.errorMsg);
}
