part of 'date_selector_bloc.dart';

abstract class DateSelectorState {}

class DateSelectorInitial extends DateSelectorState {}

class SelectingDate extends DateSelectorState {}

class SelectedDate extends DateSelectorState {
  SelectedDate();
}
