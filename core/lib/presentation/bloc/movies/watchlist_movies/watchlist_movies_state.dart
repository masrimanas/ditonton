part of 'watchlist_movies_bloc.dart';

@immutable
abstract class WatchlistMoviesState extends Equatable {}

class WatchlistMoviesEmpty extends WatchlistMoviesState {
  @override
  List<Object> get props => [];
}

class WatchlistMoviesLoading extends WatchlistMoviesState {
  @override
  List<Object> get props => [];
}

class WatchlistMoviesError extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMoviesHasData extends WatchlistMoviesState {
  final List<Movie> result;

  WatchlistMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistMoviesMessage extends WatchlistMoviesState {
  final String message;

  WatchlistMoviesMessage(this.message);

  @override
  List<Object> get props => [message];
}

class MovieIsInWatchlist extends WatchlistMoviesState {
  final bool isInWatchlist;

  MovieIsInWatchlist(this.isInWatchlist);

  @override
  List<Object> get props => [isInWatchlist];
}
