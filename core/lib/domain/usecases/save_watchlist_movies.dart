import 'package:dartz/dartz.dart';

import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../utils/failure.dart';

class SaveWatchlistMovies {
  final MovieRepository repository;

  SaveWatchlistMovies(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlistMovies(movie);
  }
}
