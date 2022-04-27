import 'package:dartz/dartz.dart';

import '../../domain/entities/series_detail.dart';
import '../../domain/repositories/series_repository.dart';
import '../../utils/failure.dart';

class GetSeriesDetail {
  final SeriesRepository repository;

  GetSeriesDetail(this.repository);

  Future<Either<Failure, SeriesDetail>> execute(int id) {
    return repository.getSeriesDetail(id);
  }
}
