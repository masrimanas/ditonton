import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_now_playing_movies.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty()) {
    on<LoadNowPlayingMovies>(_loadNowPlayingMovies);
  }

  FutureOr<void> _loadNowPlayingMovies(
    LoadNowPlayingMovies event,
    Emitter<NowPlayingMoviesState> emit,
  ) async {
    emit(NowPlayingMoviesLoading());

    final result = await _getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        emit(NowPlayingMoviesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(NowPlayingMoviesEmpty())
            : emit(NowPlayingMoviesHasData(data));
      },
    );
  }
}
