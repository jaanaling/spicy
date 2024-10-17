import 'package:application/src/core/dependency_injection.dart';
import 'package:application/src/feature/challenge/model/challenge.dart';
import 'package:application/src/feature/challenge/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
   final ChallengeRepository _repository = locator<ChallengeRepository>();

  ChallengeBloc() : super(ChallengeInitial()) {
    on<LoadChallengesEvent>(_onLoadChallenges);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ShareChallengeEvent>(_onShareChallenge);
  }

  Future<void> _onLoadChallenges(
      LoadChallengesEvent event, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      final challenges = await _repository.loadChallengesFromPrefs();
      emit(ChallengeLoaded(challenges));
    } catch (e) {
      emit(ChallengeError('Failed to load challenges'));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<ChallengeState> emit) async {
    try {
      await _repository.toggleFavorite(event.challenge);
      final updatedChallenges = await _repository.loadChallengesFromPrefs();
      emit(ChallengeLoaded(updatedChallenges));
    } catch (e) {
      emit(ChallengeError('Failed to toggle favorite'));
    }
  }

  Future<void> _onShareChallenge(
      ShareChallengeEvent event, Emitter<ChallengeState> emit) async {
    try {
      await _repository.shareChallenge(event.name);
    } catch (e) {
      emit(ChallengeError('Failed to share challenge'));
    }
  }
}