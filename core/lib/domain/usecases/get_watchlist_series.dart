import 'package:dartz/dartz.dart';

import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class GetWatchlistSeries {
  final SeriesRepository _repository;

  GetWatchlistSeries(this._repository);

  Future<Either<Failure, List<Series>>> execute() {
    return _repository.getWatchlistSeries();
  }
}
