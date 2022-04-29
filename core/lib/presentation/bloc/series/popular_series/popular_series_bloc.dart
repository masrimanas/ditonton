import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/series.dart';
import '../../../../domain/usecases/get_popular_series.dart';

part 'popular_series_event.dart';
part 'popular_series_state.dart';

class PopularSeriesBloc extends Bloc<PopularSeriesEvent, PopularSeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(PopularSeriesEmpty()) {
    on<LoadPopularSeries>(_loadPopularSeries);
  }

  FutureOr<void> _loadPopularSeries(
    LoadPopularSeries event,
    Emitter<PopularSeriesState> emit,
  ) async {
    emit(PopularSeriesLoading());

    final result = await _getPopularSeries.execute();

    result.fold(
      (failure) {
        emit(PopularSeriesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(PopularSeriesEmpty())
            : emit(PopularSeriesHasData(data));
      },
    );
  }
}
