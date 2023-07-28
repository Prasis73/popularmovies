// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:popular_movie/common/api/api_provider.dart';
import 'package:popular_movie/common/constants/constants.dart';

import 'package:popular_movie/common/errors/common_error.dart';
import 'package:popular_movie/common/services/database_services.dart';
import 'package:popular_movie/features/movies/models/movie_model.dart';

class MovieRepository {
  final ApiProvider apiProvider;
  final DatabaseService databaseService;
  MovieRepository({
    required this.apiProvider,
    required this.databaseService,
  });

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  final List<MovieModel> _favoriteMovie = [];
  List<MovieModel> get favoriteMovies => _favoriteMovie;

  int currentPage = 1;
  int totalPage = -1;

  String oldSearchQuery = "";

  Future<Either<String, List<MovieModel>>> fetchMovies(
      {bool isLoadMore = false}) async {
    try {
      if (currentPage == totalPage && isLoadMore) {
        return Right(_movies);
      }
      if (isLoadMore) {
        currentPage++;
      } else {
        currentPage = 1;
        totalPage = -1;
        _movies.clear();
      }

      final res = await apiProvider.get(
          url: '${Constants.baseUrl}/3/movie/popular',
          query: {"api_key": Constants.apiKey, "page": currentPage});
      final items =
          List.from(res["results"]).map((e) => MovieModel.fromMap(e)).toList();
      totalPage = res["total_pages"];
      for (MovieModel singleMovie in items) {
        final isFavorite = await databaseService.isFavorite(singleMovie.id);
        _movies.add(singleMovie.copyWith(favorite: isFavorite));
      }
      return Right(_movies);
    } on NetworkFailure catch (e) {
      return Left(e.message);
    } on AppFailure catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<MovieModel>>> searchFetchMovies({
    bool isLoadMore = false,
    required String searchQuery,
  }) async {
    try {
      if (currentPage == totalPage &&
          isLoadMore &&
          oldSearchQuery == searchQuery) {
        return Right(_movies);
      }

      if (isLoadMore && oldSearchQuery == searchQuery) {
        currentPage++;
      } else {
        currentPage = 1;
        totalPage = -1;
        _movies.clear();
        oldSearchQuery = searchQuery;
      }

      final res = await apiProvider.get(
        url: "${Constants.baseUrl}/3/search/movie",
        query: {
          "api_key": Constants.apiKey,
          "page": currentPage,
          "query": searchQuery,
        },
      );
      final items =
          List.from(res["results"]).map((e) => MovieModel.fromMap(e)).toList();
      totalPage = res["total_pages"];
      for (MovieModel singleMovie in items) {
        final isFavorite = await databaseService.isFavorite(singleMovie.id);
        _movies.add(singleMovie.copyWith(favorite: isFavorite));
      }
      return Right(_movies);
    } on NetworkFailure catch (e) {
      return Left(e.message);
    } on AppFailure catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> addToFavorite(MovieModel movie) async {
    try {
      final _ = await databaseService.addToFavorite(movie);
      final index = _movies.indexWhere((e) => e.id == movie.id);
      if (index != -1) {
        _movies[index] = _movies[index].copyWith(favorite: true);
      }

      final favIndex = _favoriteMovie.indexWhere((e) => e.id == movie.id);
      if (favIndex != -1) {
        _favoriteMovie[favIndex] =
            _favoriteMovie[favIndex].copyWith(favorite: true);
      }
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> unFavorite(int id) async {
    try {
      final _ = await databaseService.unFavorite(id);
      final index = _movies.indexWhere((e) => e.id == id);
      if (index != -1) {
        _movies[index] = _movies[index].copyWith(favorite: false);
      }

      final favIndex = _favoriteMovie.indexWhere((e) => e.id == id);
      if (favIndex != -1) {
        _favoriteMovie[favIndex] =
            _favoriteMovie[favIndex].copyWith(favorite: false);
      }
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> isFavorite(int id) async {
    try {
      final res = await databaseService.isFavorite(id);
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<MovieModel>>> getFavorites() async {
    try {
      final res = await databaseService.getAllFavorite();
      _favoriteMovie.clear();
      _favoriteMovie.addAll(res);
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
