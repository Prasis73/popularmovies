import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/features/cubit/favourite_movie_cubit.dart';

import 'package:popular_movie/features/models/movie_model.dart';

import '../../../common/cubit/common_state.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            movie.posterImage,
            fit: BoxFit.cover,
            height: 240,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BlocBuilder<FavoriteCubit, CommonState>(
                  builder: (context, state) {
                if (state is CommonSuccessState<bool>) {
                  return IconButton(
                    onPressed: () {
                      if (state.item) {
                        context.read<FavoriteCubit>().unfavorite(movie.id);
                      } else {
                        context.read<FavoriteCubit>().favorite(movie);
                      }
                    },
                    icon: Icon(
                      state.item
                          ? Icons.favorite_outlined
                          : Icons.favorite_outline_outlined,
                    ),
                  );
                } else {
                  return const CupertinoActivityIndicator();
                }
              })
            ],
          ),
        ),
      ],
    );
  }
}
