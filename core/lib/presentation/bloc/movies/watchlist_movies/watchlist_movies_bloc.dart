import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movies_status.dart';
import 'package:core/domain/usecases/remove_watchlist_movies.dart';
import 'package:core/domain/usecases/save_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/movie.dart';
import '../../../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListMoviesStatus _getWatchListMoviesStatus;
  final RemoveWatchlistMovies _removeWatchlistMovies;
  final SaveWatchlistMovies _saveWatchlistMovies;

  WatchlistMoviesBloc(
    this._getWatchlistMovies,
    this._getWatchListMoviesStatus,
    this._removeWatchlistMovies,
    this._saveWatchlistMovies,
  ) : super(WatchlistMoviesEmpty()) {
    on<LoadWatchlistMovies>(_loadWatchlistMovies);
    on<LoadWatchlistMoviesStatus>(_loadWatchlistMoviesStatus);
    on<AddMovieToWatchlist>(_addMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_removeMovieFromWatchlist);
  }

  FutureOr<void> _loadWatchlistMovies(
    LoadWatchlistMovies event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(WatchlistMoviesLoading());

    final result = await _getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(WatchlistMoviesEmpty())
            : emit(WatchlistMoviesHasData(data));
      },
    );
  }

  FutureOr<void> _loadWatchlistMoviesStatus(
    LoadWatchlistMoviesStatus event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _getWatchListMoviesStatus.execute(event.id);
    emit(MovieIsInWatchlist(result));
  }

  Future<void> _addMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _saveWatchlistMovies.execute(event.movie);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (message) {
        emit(WatchlistMoviesMessage(message));
      },
    );
  }

  Future<void> _removeMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    final result = await _removeWatchlistMovies.execute(event.movie);

    result.fold(
      (failure) {
        emit(WatchlistMoviesError(failure.message));
      },
      (message) {
        emit(WatchlistMoviesMessage(message));
      },
    );
  }
}
