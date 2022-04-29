import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/usecases/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;

  MovieDetailBloc(this._getMovieDetail) : super(MovieDetailEmpty()) {
    on<LoadMovieDetail>(_loadMovieDetail);
  }

  FutureOr<void> _loadMovieDetail(
    LoadMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());

    final result = await _getMovieDetail.execute(event.id);

    result.fold(
      (failure) {
        emit(MovieDetailError(failure.message));
      },
      (data) {
        emit(MovieDetailHasData(data));
      },
    );
  }
}
