part of 'series_recommendations_bloc.dart';

@immutable
abstract class SeriesRecommendationsEvent extends Equatable {}

class LoadSeriesRecommendations extends SeriesRecommendationsEvent {
  final int id;

  LoadSeriesRecommendations(this.id);

  @override
  List<Object> get props => [];
}
