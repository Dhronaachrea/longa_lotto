part of 'ige_game_bloc.dart';

@immutable
abstract class IgeGameEvent {}

class FetchIgeGame extends IgeGameEvent {
  final BuildContext context;

  FetchIgeGame({required this.context});
}
