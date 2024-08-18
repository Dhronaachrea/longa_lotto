part of 'dge_game_bloc.dart';

@immutable
abstract class DgeGameEvent {}

class FetchDgeGame extends DgeGameEvent {
  final BuildContext context;

  FetchDgeGame({required this.context});
}
