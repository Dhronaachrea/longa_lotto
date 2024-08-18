part of 'ticket_bloc.dart';

@immutable
abstract class TicketEvent {}

class GetTicket extends TicketEvent {
  final BuildContext context;
  final int offset;
  final int limit;
  final String fromDate;
  final String toDate;
  bool isPagination;

  GetTicket({
    required this.context,
    required this.offset,
    required this.limit ,
    required this.fromDate ,
    required this.toDate,
    this.isPagination = false
  });
}
