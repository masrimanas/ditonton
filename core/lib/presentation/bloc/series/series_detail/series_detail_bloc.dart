import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/usecases/get_series_detail.dart';

part 'series_detail_event.dart';
part 'series_detail_state.dart';

class SeriesDetailBloc extends Bloc<SeriesDetailEvent, SeriesDetailState> {
  final GetSeriesDetail _getSeriesDetail;

  SeriesDetailBloc(this._getSeriesDetail) : super(SeriesDetailEmpty()) {
    on<LoadSeriesDetail>(_loadSeriesDetail);
  }

  FutureOr<void> _loadSeriesDetail(
    LoadSeriesDetail event,
    Emitter<SeriesDetailState> emit,
  ) async {
    emit(SeriesDetailLoading());

    final result = await _getSeriesDetail.execute(event.id);

    result.fold(
      (failure) {
        emit(SeriesDetailError(failure.message));
      },
      (data) {
        emit(SeriesDetailHasData(data));
      },
    );
  }
}
