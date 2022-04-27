part of 'search_series_bloc.dart';

abstract class SearchSeriesEvent extends Equatable {
  const SearchSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchSeriesEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
