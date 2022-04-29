import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMoviesEmpty()) {
    on<LoadTopRatedMovies>(_loadTopRatedMovies);
  }

  FutureOr<void> _loadTopRatedMovies(
    LoadTopRatedMovies event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(TopRatedMoviesLoading());

    final result = await _getTopRatedMovies.execute();

    result.fold(
      (failure) {
        emit(TopRatedMoviesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(TopRatedMoviesEmpty())
            : emit(TopRatedMoviesHasData(data));
      },
    );
  }
}
