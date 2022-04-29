part of 'now_playing_movies_bloc.dart';

@immutable
abstract class NowPlayingMoviesEvent extends Equatable {}

class LoadNowPlayingMovies extends NowPlayingMoviesEvent {
  @override
  List<Object> get props => [];
}
