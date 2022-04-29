import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/series.dart';
import '../../../../domain/usecases/get_top_rated_series.dart';

part 'top_rated_series_event.dart';
part 'top_rated_series_state.dart';

class TopRatedSeriesBloc
    extends Bloc<TopRatedSeriesEvent, TopRatedSeriesState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesBloc(this._getTopRatedSeries) : super(TopRatedSeriesEmpty()) {
    on<LoadTopRatedSeries>(_loadTopRatedSeries);
  }

  FutureOr<void> _loadTopRatedSeries(
    LoadTopRatedSeries event,
    Emitter<TopRatedSeriesState> emit,
  ) async {
    emit(TopRatedSeriesLoading());

    final result = await _getTopRatedSeries.execute();

    result.fold(
      (failure) {
        emit(TopRatedSeriesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(TopRatedSeriesEmpty())
            : emit(TopRatedSeriesHasData(data));
      },
    );
  }
}
