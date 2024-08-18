part of 'ige_game_bloc.dart';

@immutable
abstract class IgeGameState {}

class IgeGameInitial extends IgeGameState {}

class FetchingIgeGame extends IgeGameState {}

class FetchIgeGameError extends IgeGameState {
  final String errorMessage;

  FetchIgeGameError({required this.errorMessage});
}

class FetchedIgeGame extends IgeGameState {
  final IgeGameResponse igeGameResponse;

  FetchedIgeGame({required this.igeGameResponse});
}
