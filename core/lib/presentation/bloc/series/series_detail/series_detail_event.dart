part of 'series_detail_bloc.dart';

@immutable
abstract class SeriesDetailEvent extends Equatable {}

class LoadSeriesDetail extends SeriesDetailEvent {
  final int id;

  LoadSeriesDetail(this.id);

  @override
  List<Object> get props => [];
}
