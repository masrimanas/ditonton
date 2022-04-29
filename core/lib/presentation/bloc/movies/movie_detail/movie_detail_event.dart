part of 'movie_detail_bloc.dart';

@immutable
abstract class MovieDetailEvent extends Equatable {}

class LoadMovieDetail extends MovieDetailEvent {
  final int id;

  LoadMovieDetail(this.id);

  @override
  List<Object> get props => [];
}
