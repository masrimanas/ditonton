import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/series.dart';
import '../../../../domain/usecases/get_series_recommendations.dart';

part 'series_recommendations_event.dart';
part 'series_recommendations_state.dart';

class SeriesRecommendationsBloc
    extends Bloc<SeriesRecommendationsEvent, SeriesRecommendationsState> {
  final GetSeriesRecommendations _getSeriesRecommendations;

  SeriesRecommendationsBloc(this._getSeriesRecommendations)
      : super(SeriesRecommendationsEmpty()) {
    on<LoadSeriesRecommendations>(_loadSeriesRecommendations);
  }

  FutureOr<void> _loadSeriesRecommendations(
    LoadSeriesRecommendations event,
    Emitter<SeriesRecommendationsState> emit,
  ) async {
    emit(SeriesRecommendationsLoading());

    final result = await _getSeriesRecommendations.execute(event.id);

    result.fold(
      (failure) {
        emit(SeriesRecommendationsError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(SeriesRecommendationsEmpty())
            : emit(SeriesRecommendationsHasData(data));
      },
    );
  }
}
