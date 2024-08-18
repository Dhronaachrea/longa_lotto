part of 'inbox_bloc.dart';

@immutable
abstract class InboxEvent {}

class GetInbox extends InboxEvent {
  final int offset;
  final bool isPagination;
  final BuildContext context;

  GetInbox({
    required this.offset,
    this.isPagination = false,
    required this.context,
  });
}

class InboxActivity extends InboxEvent {
  final BuildContext context;
  final String activity;
  final String inboxId;

  InboxActivity({required this.context, required this.activity, required this.inboxId});
}

class InboxActivityMarkRead extends InboxEvent {
  final BuildContext context;
  final String activity;
  final String inboxId;

  InboxActivityMarkRead({required this.context, required this.activity, required this.inboxId});
}

class InboxSearch extends InboxEvent {
  final BuildContext context;
  final String query;
  final List<PlrInboxList> inboxList;

  InboxSearch(
      {required this.context, required this.query, required this.inboxList});
}
