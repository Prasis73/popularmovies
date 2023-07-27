import 'package:bloc/bloc.dart';

import '../../common/cubit/common_state.dart';
import '../resources/movie_repository.dart';

class FetchAllFavoriteCubit extends Cubit<CommonState> {
  final MovieRepository repository;
  FetchAllFavoriteCubit({required this.repository})
      : super(CommonInitialState());

  fetchMovie() async {
    emit(CommonLoadingState());
    final res = await repository.getFavorites();
    res.fold(
      (err) => emit(CommonErrorState(message: err)),
      (data) => emit(CommonSuccessState(item: data)),
    );
  }
}
