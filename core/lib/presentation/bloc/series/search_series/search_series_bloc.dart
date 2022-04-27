import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';

import '../../../../domain/usecases/search_series.dart';
import '../../../../domain/entities/series.dart';

part 'search_series_event.dart';
part 'search_series_state.dart';

class SearchSeriesBloc extends Bloc<SearchSeriesEvent, SearchSeriesState> {
  final SearchSeries _searchSeries;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  SearchSeriesBloc(this._searchSeries) : super(SearchSeriesEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchSeriesLoading());
      final result = await _searchSeries.execute(query);

      result.fold(
        (failure) {
          emit(SearchSeriesError(failure.message));
        },
        (data) {
          emit(SearchSeriesHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 750)));
  }
}
