part of 'watchlist_movies_bloc.dart';

@immutable
abstract class WatchlistMoviesEvent extends Equatable {}

class LoadWatchlistMovies extends WatchlistMoviesEvent {
  @override
  List<Object> get props => [];
}

class LoadWatchlistMoviesStatus extends WatchlistMoviesEvent {
  final int id;

  LoadWatchlistMoviesStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlist extends WatchlistMoviesEvent {
  final MovieDetail movie;

  AddMovieToWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlist extends WatchlistMoviesEvent {
  final MovieDetail movie;

  RemoveMovieFromWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
