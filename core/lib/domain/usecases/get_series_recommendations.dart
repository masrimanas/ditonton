import 'package:dartz/dartz.dart';

import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class GetSeriesRecommendations {
  final SeriesRepository repository;

  GetSeriesRecommendations(this.repository);

  Future<Either<Failure, List<Series>>> execute(id) {
    return repository.getSeriesRecommendations(id);
  }
}
