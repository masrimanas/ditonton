part of 'popular_series_bloc.dart';

@immutable
abstract class PopularSeriesEvent extends Equatable {}

class LoadPopularSeries extends PopularSeriesEvent {
  @override
  List<Object> get props => [];
}
