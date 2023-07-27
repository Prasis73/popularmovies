// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/features/cubit/favourite_movie_cubit.dart';

import 'package:popular_movie/features/models/movie_model.dart';
import 'package:popular_movie/features/resources/movie_repository.dart';

import '../widgets/details_widget.dart';

class MovieDetailPage extends StatelessWidget {
  final MovieModel movie;
  const MovieDetailPage({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteCubit(
        initialValue: movie.favorite,
        repository: context.read<MovieRepository>(),
      ),
      child: DetailsWidget(movie: movie),
    );
  }
}
