part of 'watchlist_series_bloc.dart';

@immutable
abstract class WatchlistSeriesState extends Equatable {}

class WatchlistSeriesEmpty extends WatchlistSeriesState {
  @override
  List<Object> get props => [];
}

class WatchlistSeriesLoading extends WatchlistSeriesState {
  @override
  List<Object> get props => [];
}

class WatchlistSeriesError extends WatchlistSeriesState {
  final String message;

  WatchlistSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistSeriesHasData extends WatchlistSeriesState {
  final List<Series> result;

  WatchlistSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistSeriesMessage extends WatchlistSeriesState {
  final String message;

  WatchlistSeriesMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SeriesIsInWatchlist extends WatchlistSeriesState {
  final bool isInWatchlist;

  SeriesIsInWatchlist(this.isInWatchlist);

  @override
  List<Object> get props => [isInWatchlist];
}
