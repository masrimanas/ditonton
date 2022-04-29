part of 'on_going_series_bloc.dart';

@immutable
abstract class OnGoingSeriesEvent extends Equatable {}

class LoadOnGoingSeries extends OnGoingSeriesEvent {
  @override
  List<Object> get props => [];
}
