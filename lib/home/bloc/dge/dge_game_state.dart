part of 'dge_game_bloc.dart';

@immutable
abstract class DgeGameState {}

class DgeGameInitial extends DgeGameState {}

class FetchingDgeGame extends DgeGameState {}

class FetchDgeGameError extends DgeGameState {
  final String errorMessage;

  FetchDgeGameError({required this.errorMessage});
}

class FetchedDgeGame extends DgeGameState {
  final DgeGameResponse dgeGameResponse;

  FetchedDgeGame({required this.dgeGameResponse});
}