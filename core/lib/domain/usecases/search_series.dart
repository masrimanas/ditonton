import 'package:dartz/dartz.dart';

import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class SearchSeries {
  final SeriesRepository repository;

  SearchSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute(String query) {
    return repository.searchSeries(query);
  }
}
