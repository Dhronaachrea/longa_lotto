import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:longa_lotto/common/constant/date_format.dart';
import 'package:longa_lotto/common/utils.dart';

part 'date_selector_event.dart';

part 'date_selector_state.dart';

class DateSelectorBloc extends Bloc<DateSelectorEvent, DateSelectorState> {
  DateSelectorBloc() : super(DateSelectorInitial()) {
    on<SelectDate>(onSelectDate);
  }

  String fromDate = formatDate(
    date: DateTime.now().subtract(const Duration(days: 30)).toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.calendarFormat,
  );

  String toDate = formatDate(
    date: DateTime.now().toString(),
    inputFormat: Format.apiDateFormat2,
    outputFormat: Format.calendarFormat,
  );

  Future<FutureOr<void>> onSelectDate(
      SelectDate event, Emitter<DateSelectorState> emit) async {
    var context = event.context;
    log("Select Date");
    emit(SelectingDate());
    DateTimeRange? pickedDateRange = await showCalendar(
      context,
      DateTime.now().subtract(const Duration(days: 30)),
      DateTime.now(),
    );
    if (pickedDateRange != null) {
      log("pickedDataStart ${pickedDateRange.start}");
      log("pickedDataEnd ${pickedDateRange.end}");
      fromDate = formatDate(
        date: pickedDateRange.start.toString(),
        inputFormat: Format.apiDateFormat2,
        outputFormat: Format.calendarFormat,
      );
      toDate = formatDate(
        date: pickedDateRange.end.toString(),
        inputFormat: Format.apiDateFormat2,
        outputFormat: Format.calendarFormat,
      );
      emit(
        SelectedDate(),
      );
    }
  }
}
