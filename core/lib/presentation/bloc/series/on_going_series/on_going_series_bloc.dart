import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/series.dart';
import '../../../../domain/usecases/get_on_going_series.dart';

part 'on_going_series_event.dart';
part 'on_going_series_state.dart';

class OnGoingSeriesBloc extends Bloc<OnGoingSeriesEvent, OnGoingSeriesState> {
  final GetOnGoingSeries _getOnGoingSeries;

  OnGoingSeriesBloc(this._getOnGoingSeries) : super(OnGoingSeriesEmpty()) {
    on<LoadOnGoingSeries>(_loadOnGoingSeries);
  }

  FutureOr<void> _loadOnGoingSeries(
    LoadOnGoingSeries event,
    Emitter<OnGoingSeriesState> emit,
  ) async {
    emit(OnGoingSeriesLoading());

    final result = await _getOnGoingSeries.execute();

    result.fold(
      (failure) {
        emit(OnGoingSeriesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(OnGoingSeriesEmpty())
            : emit(OnGoingSeriesHasData(data));
      },
    );
  }
}
