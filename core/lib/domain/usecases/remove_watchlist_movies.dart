import 'package:dartz/dartz.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../utils/failure.dart';

class RemoveWatchlistMovies {
  final MovieRepository repository;

  RemoveWatchlistMovies(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlistMovies(movie);
  }
}
