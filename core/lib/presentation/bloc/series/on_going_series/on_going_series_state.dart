part of 'on_going_series_bloc.dart';

@immutable
abstract class OnGoingSeriesState extends Equatable {}

class OnGoingSeriesEmpty extends OnGoingSeriesState {
  @override
  List<Object> get props => [];
}

class OnGoingSeriesLoading extends OnGoingSeriesState {
  @override
  List<Object> get props => [];
}

class OnGoingSeriesError extends OnGoingSeriesState {
  final String message;

  OnGoingSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class OnGoingSeriesHasData extends OnGoingSeriesState {
  final List<Series> result;

  OnGoingSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
