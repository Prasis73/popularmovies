import 'package:bloc/bloc.dart';

import 'package:popular_movie/features/cubit/movie_event.dart';
import 'package:popular_movie/features/resources/movie_repository.dart';

import '../../common/cubit/common_state.dart';

class FetchMovieListBloc extends Bloc<MovieEvent, CommonState> {
  final MovieRepository repository;
  FetchMovieListBloc({
    required this.repository,
  }) : super(CommonInitialState()) {
    on<FetchMovieEvent>((event, emit) async {
      emit(CommonLoadingState());

      //  if(event.query.isEmpty){
      final res = await repository.fetchMovies();
      res.fold((err) {
        emit(CommonErrorState(message: err));
      }, (data) {
        emit(CommonSuccessState(item: data));
      });
      //  }
    });
  }
}
