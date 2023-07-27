import 'package:bloc/bloc.dart';

import '../../common/cubit/common_state.dart';
import '../models/movie_model.dart';
import '../resources/movie_repository.dart';

class FavoriteCubit extends Cubit<CommonState> {
  final MovieRepository repository;
  FavoriteCubit({required this.repository}) : super(CommonInitialState());

  initial(int id) async {
    emit(CommonLoadingState());
    final res = await repository.isFavorite(id);
    res.fold(
      (err) {
        emit(CommonErrorState(message: err));
        emit(CommonSuccessState<bool>(item: false));
      },
      (data) => emit(CommonSuccessState<bool>(item: data)),
    );
  }

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
