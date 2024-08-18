part of 'home_timer_bloc.dart';

abstract class HomeTimerEvent {
  const HomeTimerEvent();
}

class TimerStarted extends HomeTimerEvent {
  final DateTime drawDateTime;
  final DateTime currentDateTime;

  const TimerStarted({
    required this.drawDateTime,
    required this.currentDateTime,
  });
}

class TimerReset extends HomeTimerEvent {
  const TimerReset();
}

class TimerTicked extends HomeTimerEvent {
  final int timeDiff;

  TimerTicked(this.timeDiff);
}
