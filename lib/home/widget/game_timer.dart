part of 'home_widget.dart';

class GameTimer extends StatefulWidget {
  final GameRespVo dgeGame;
  final DateTime? currentTime;
  final DateTime? drawDateTime;
  final VoidCallback onTimerCompleted;

  const GameTimer({
    Key? key,
    required this.dgeGame,
    required this.currentTime,
    required this.drawDateTime,
    required this.onTimerCompleted,
  }) : super(key: key);

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late ShakeController hurryUpShakeController;
  bool showHurry = false;

  @override
  void initState() {
    init();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    hurryUpShakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String days = '00';
    String hours = '00';
    String minutes = '00';
    String seconds = '00';
    return BlocBuilder<HomeTimerBloc, HomeTimerState>(
      builder: (context, state) {
        log("game timer state: ${widget.dgeGame.gameName} $state");
        log("game timer state drawDateTime: ${widget.dgeGame.gameName} ${widget.drawDateTime} ");
        if(state is HomeTimerInitial) {
          days = '00';
          hours = '00';
          minutes = '00';
          seconds = '00';
          showHurry = false;
          context.read<HomeTimerBloc>().add(const TimerReset());
          startTimer();
        }
        if (state is TimerRunInProgress) {
          days = state.days;
          hours = state.hours;
          minutes = state.minutes;
          seconds = state.seconds;
          showHurry = state.showHurry;
          log("showHurry:$showHurry ");
        }
        if (state is TimerRunComplete) {
          days = '00';
          hours = '00';
          minutes = '00';
          seconds = '00';
          showHurry = false;
          context.read<HomeTimerBloc>().add(const TimerReset());
          log("on timer will be called");
          widget.onTimerCompleted();
          log("on timer is   called");
        }
        return Column(
          children: [
            showHurry == true
                ? ShakeWidget(
                    controller: hurryUpShakeController,
                    child: BlinkingAnimation(text: context.l10n.hurry_up),
                  ).pSymmetric(v:5)
                : Text(
                    context.l10n.end_in,
                    style: TextStyle(color: LongaColor.black_four),
                  ).pSymmetric(v:5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimeWidget(title: context.l10n.d.toUpperCase(), counter: days),
                TimeWidget(title: context.l10n.h.toUpperCase(), counter: hours),
                TimeWidget(
                    title: context.l10n.m.toUpperCase(), counter: minutes),
                TimeWidget(
                    title: context.l10n.s.toUpperCase(), counter: seconds),
              ],
            ),
          ],
        );
      },
    );
  }

  void init() {
    hurryUpShakeController = ShakeController();
  }

  void startTimer() {
    if( widget.drawDateTime != null){
      BlocProvider.of<HomeTimerBloc>(context).add(
        TimerStarted(
          drawDateTime: widget.drawDateTime!,
          // drawDateTime: DateTime.now().add(Duration(days: 30)),
          currentDateTime: widget.currentTime!,
        ),
      );
    }
  }
}

class TimeWidget extends StatefulWidget {
  final String title;
  final String counter;

  const TimeWidget({Key? key, required this.title, required this.counter})
      : super(key: key);

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 25.0,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      color: LongaColor.white,
      child: Column(
        children: [
          Text(widget.counter),
          Text(widget.title),
        ],
      ),
    );
  }
}
