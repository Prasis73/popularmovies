import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:popular_movie/common/cubit/common_state.dart';

import 'package:popular_movie/features/movies/cubit/movie_event.dart';
import 'package:popular_movie/features/movies/resources/movie_repository.dart';

import '../models/movie_model.dart';

class FetchMovieListBloc extends Bloc<MovieEvent, CommonState> {
  final MovieRepository repository;
  FetchMovieListBloc({
    required this.repository,
  }) : super(CommonInitialState()) {
    on<FetchMovieEvent>((event, emit) async {
      emit(CommonLoadingState());

      if (event.query.isEmpty) {
        final res = await repository.fetchMovies();
        res.fold((err) {
          emit(CommonErrorState(message: err));
        }, (data) {
          emit(CommonSuccessState(item: data));
        });
      } else {
        final res =
            await repository.searchFetchMovies(searchQuery: event.query);
        res.fold(
          (err) => emit(CommonErrorState(message: err)),
          (data) => emit(CommonSuccessState<List<MovieModel>>(item: data)),
        );
      }
    });

    on<LoadMoreMovieEvent>(
      (event, emit) async {
        emit(CommonLoadingState(showLoading: false));
        if (event.query.isEmpty) {
          final _ = await repository.fetchMovies(isLoadMore: true);
          emit(CommonSuccessState<List<MovieModel>>(item: repository.movies));
        } else {
          final _ = await repository.searchFetchMovies(
              searchQuery: event.query, isLoadMore: true);
          emit(CommonSuccessState<List<MovieModel>>(item: repository.movies));
        }
      },
      transformer: droppable(),
    );

    on<ReloadMovieEvent>(
      (event, emit) async {
        emit(CommonLoadingState());
        emit(CommonSuccessState<List<MovieModel>>(item: repository.movies));
      },
    );
  }
}
