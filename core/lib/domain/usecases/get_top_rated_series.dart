import 'package:dartz/dartz.dart';

import '../../domain/entities/series.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class GetTopRatedSeries {
  final SeriesRepository repository;

  GetTopRatedSeries(this.repository);

  Future<Either<Failure, List<Series>>> execute() {
    return repository.getTopRatedSeries();
  }
}
