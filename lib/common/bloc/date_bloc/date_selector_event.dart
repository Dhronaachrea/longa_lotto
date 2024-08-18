part of 'date_selector_bloc.dart';


abstract class DateSelectorEvent {}

class SelectDate extends DateSelectorEvent{
  BuildContext context;
  SelectDate({required this.context});

}
