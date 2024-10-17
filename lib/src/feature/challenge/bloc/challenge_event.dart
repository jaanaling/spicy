part of 'challenge_bloc.dart';

abstract class ChallengeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChallengesEvent extends ChallengeEvent {}

class ToggleFavoriteEvent extends ChallengeEvent {
  final ChallengeRecipe challenge;

  ToggleFavoriteEvent(this.challenge);

  @override
  List<Object?> get props => [challenge];
}

class ShareChallengeEvent extends ChallengeEvent {
  final String name;

  ShareChallengeEvent(this.name);

  @override
  List<Object?> get props => [name];
}
