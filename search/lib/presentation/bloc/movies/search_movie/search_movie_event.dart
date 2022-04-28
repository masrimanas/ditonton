part of 'search_movie_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryMovieChanged extends SearchEvent {
  final String query;

  OnQueryMovieChanged(this.query);

  @override
  List<Object> get props => [query];
}
