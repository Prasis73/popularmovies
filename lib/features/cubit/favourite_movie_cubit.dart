import 'package:bloc/bloc.dart';
import 'package:popular_movie/common/cubit/common_state.dart';
import 'package:popular_movie/features/models/movie_model.dart';
import 'package:popular_movie/features/resources/movie_repository.dart';

class FavoriteCubit extends Cubit<CommonState> {
  final MovieRepository repository;
  final bool initialValue;
  FavoriteCubit({required this.repository, required this.initialValue})
      : super(CommonSuccessState<bool>(item: initialValue));

  favorite(MovieModel movie) async {
    emit(CommonLoadingState());
    final res = await repository.addToFavorite(movie);
    res.fold(
      (err) {
        emit(CommonErrorState(message: err));
        emit(CommonSuccessState<bool>(item: false));
      },
      (data) => emit(CommonSuccessState<bool>(item: true)),
    );
  }

  unfavorite(int id) async {
    emit(CommonLoadingState());
    final res = await repository.unFavorite(id);
    res.fold(
      (err) {
        emit(CommonErrorState(message: err));
        emit(CommonSuccessState<bool>(item: true));
      },
      (data) => emit(CommonSuccessState<bool>(item: false)),
    );
  }
}
