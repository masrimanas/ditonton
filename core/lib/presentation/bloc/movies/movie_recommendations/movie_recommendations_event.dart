part of 'movie_recommendations_bloc.dart';

@immutable
abstract class MovieRecommendationsEvent extends Equatable {}

class LoadMovieRecommendations extends MovieRecommendationsEvent {
  final int id;

  LoadMovieRecommendations(this.id);

  @override
  List<Object> get props => [];
}
