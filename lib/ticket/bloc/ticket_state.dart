part of 'ticket_bloc.dart';

@immutable
abstract class TicketState {}

class TicketInitial extends TicketState {}

class DateUpdated extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<TicketList>? ticketList;

  TicketLoaded({this.ticketList = const []});
}

class TicketLoadingError extends TicketState {
  final String errorMessage;

  TicketLoadingError({required this.errorMessage});
}
