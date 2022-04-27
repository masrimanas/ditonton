import 'package:dartz/dartz.dart';

import '../../domain/entities/series_detail.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class RemoveWatchlistSeries {
  final SeriesRepository repository;

  RemoveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlistSeries(series);
  }
}
