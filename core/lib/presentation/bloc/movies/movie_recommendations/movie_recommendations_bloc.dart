import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_movie_recommendations.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationsBloc
    extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations)
      : super(MovieRecommendationsEmpty()) {
    on<LoadMovieRecommendations>(_loadMovieRecommendations);
  }

  FutureOr<void> _loadMovieRecommendations(
    LoadMovieRecommendations event,
    Emitter<MovieRecommendationsState> emit,
  ) async {
    emit(MovieRecommendationsLoading());

    final result = await _getMovieRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(MovieRecommendationsError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(MovieRecommendationsEmpty())
            : emit(MovieRecommendationsHasData(data));
      },
    );
  }
}
