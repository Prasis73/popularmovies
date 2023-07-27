import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/features/cubit/fetch_all_favourite_cubit.dart';

import '../../resources/movie_repository.dart';
import '../widgets/favourite_widget.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchAllFavoriteCubit(
        repository: context.read<MovieRepository>(),
      )..fetchMovie(),
      child: const FavouriteWidget(),
    );
  }
}
