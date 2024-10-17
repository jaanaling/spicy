part of 'challenge_bloc.dart';

abstract class ChallengeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChallengeInitial extends ChallengeState {}

class ChallengeLoading extends ChallengeState {}

class ChallengeLoaded extends ChallengeState {
  final List<ChallengeRecipe> challenges;

  ChallengeLoaded(this.challenges);

  @override
  List<Object?> get props => [challenges];
}

class ChallengeError extends ChallengeState {
  final String error;

  ChallengeError(this.error);

  @override
  List<Object?> get props => [error];
}