// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:popular_movie/common/errors/common_error.dart';
import 'package:popular_movie/features/models/movie_model.dart';

import '../../common/api/api_provider.dart';
import '../../common/constants/constants.dart';

class MovieRepository {
  final ApiProvider apiProvider;
  MovieRepository({
    required this.apiProvider,
  });

  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

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
      _movies.addAll(items);
      return Right(_movies);
    } on NetworkFailure catch (e) {
      return Left(e.message);
    } on AppFailure catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
