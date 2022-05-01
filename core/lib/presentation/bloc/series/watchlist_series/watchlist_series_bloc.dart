import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/series_detail.dart';
import 'package:core/domain/usecases/get_watchlist_series_status.dart';
import 'package:core/domain/usecases/remove_watchlist_series.dart';
import 'package:core/domain/usecases/save_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/series.dart';
import '../../../../domain/usecases/get_watchlist_series.dart';

part 'watchlist_series_event.dart';
part 'watchlist_series_state.dart';

class WatchlistSeriesBloc
    extends Bloc<WatchlistSeriesEvent, WatchlistSeriesState> {
  final GetWatchlistSeries _getWatchlistSeries;
  final GetWatchListSeriesStatus _getWatchListSeriesStatus;
  final RemoveWatchlistSeries _removeWatchlistSeries;
  final SaveWatchlistSeries _saveWatchlistSeries;

  WatchlistSeriesBloc(
    this._getWatchlistSeries,
    this._getWatchListSeriesStatus,
    this._removeWatchlistSeries,
    this._saveWatchlistSeries,
  ) : super(WatchlistSeriesEmpty()) {
    on<LoadWatchlistSeries>(_loadWatchlistSeries);
    on<LoadWatchlistSeriesStatus>(_loadWatchlistSeriesStatus);
    on<AddSeriesToWatchlist>(_addSeriesToWatchlist);
    on<RemoveSeriesFromWatchlist>(_removeSeriesFromWatchlist);
  }

  FutureOr<void> _loadWatchlistSeries(
    LoadWatchlistSeries event,
    Emitter<WatchlistSeriesState> emit,
  ) async {
    emit(WatchlistSeriesLoading());

    final result = await _getWatchlistSeries.execute();

    result.fold(
      (failure) {
        emit(WatchlistSeriesError(failure.message));
      },
      (data) {
        data.isEmpty
            ? emit(WatchlistSeriesEmpty())
            : emit(WatchlistSeriesHasData(data));
      },
    );
  }

  FutureOr<void> _loadWatchlistSeriesStatus(
    LoadWatchlistSeriesStatus event,
    Emitter<WatchlistSeriesState> emit,
  ) async {
    final result = await _getWatchListSeriesStatus.execute(event.id);
    emit(SeriesIsInWatchlist(result));
  }

  Future<void> _addSeriesToWatchlist(
    AddSeriesToWatchlist event,
    Emitter<WatchlistSeriesState> emit,
  ) async {
    final result = await _saveWatchlistSeries.execute(event.series);

    result.fold(
      (failure) {
        emit(WatchlistSeriesError(failure.message));
      },
      (message) {
        emit(WatchlistSeriesMessage(message));
      },
    );
  }

  Future<void> _removeSeriesFromWatchlist(
    RemoveSeriesFromWatchlist event,
    Emitter<WatchlistSeriesState> emit,
  ) async {
    final result = await _removeWatchlistSeries.execute(event.series);

    result.fold(
      (failure) {
        emit(WatchlistSeriesError(failure.message));
      },
      (message) {
        emit(WatchlistSeriesMessage(message));
      },
    );
  }
}
