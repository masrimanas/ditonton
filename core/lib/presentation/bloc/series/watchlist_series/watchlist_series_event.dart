part of 'watchlist_series_bloc.dart';

@immutable
abstract class WatchlistSeriesEvent extends Equatable {}

class LoadWatchlistSeries extends WatchlistSeriesEvent {
  @override
  List<Object> get props => [];
}

class LoadWatchlistSeriesStatus extends WatchlistSeriesEvent {
  final int id;

  LoadWatchlistSeriesStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddSeriesToWatchlist extends WatchlistSeriesEvent {
  final SeriesDetail series;

  AddSeriesToWatchlist(this.series);

  @override
  List<Object> get props => [series];
}

class RemoveSeriesFromWatchlist extends WatchlistSeriesEvent {
  final SeriesDetail series;

  RemoveSeriesFromWatchlist(this.series);

  @override
  List<Object> get props => [series];
}
