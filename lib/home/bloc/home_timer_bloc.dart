import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:longa_lotto/home/bloc/ticker.dart';

part 'home_timer_event.dart';
part 'home_timer_state.dart';

class HomeTimerBloc extends Bloc<HomeTimerEvent, HomeTimerState> {
  final Ticker _ticker = const Ticker();
  StreamSubscription<int>? _tickerSubscription;

  HomeTimerBloc() : super(const HomeTimerInitial()) {
    on<TimerStarted>(_onStarted);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  @override
  Future<void> close() async {
    _tickerSubscription?.cancel();
    return super.close();
  }

  _onStarted(TimerStarted event, Emitter<HomeTimerState> emit) {
    int timeDiff = 0;

    DateTime drawDateTime = event.drawDateTime;
    DateTime currentDateTime = event.currentDateTime;
    try {
      timeDiff = drawDateTime.difference(currentDateTime).inSeconds;
    } catch (e) {
      log("Exception Draw Date time @ initState : $e");
    }

    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: timeDiff - 1)
        .listen((duration) => add(TimerTicked(duration)));
  }

  _onReset(TimerReset event, Emitter<HomeTimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const HomeTimerInitial());
  }

  _onTicked(TimerTicked event, Emitter<HomeTimerState> emit) {
    int timeDiff = event.timeDiff;
    int days = timeDiff ~/ (24 * 60 * 60);
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;

    String strDays = days.toString().padLeft(2, '0');
    String strHours = hours.toString().padLeft(2, '0');
    String strMinutes = minutes.toString().padLeft(2, '0');
    String strSeconds = seconds.toString().padLeft(2, '0');

    if (timeDiff > 0) {
      log(" (days == 0 && hours == 0 && minutes == 0 && seconds > 0) : ${ (days == 0 && hours == 0 && minutes == 0 && seconds > 0)}");
      emit(TimerRunInProgress(
        days: strDays,
        hours: strHours,
        minutes: strMinutes,
        seconds: strSeconds,
        showHurry: (days == 0 && hours == 0 && minutes == 0 && seconds > 0),
      ));
    } else {
      timeDiff = 0;
      _tickerSubscription?.cancel();
      emit(const TimerRunComplete());
    }
  }
}
