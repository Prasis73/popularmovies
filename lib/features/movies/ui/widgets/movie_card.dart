import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/common/cubit/common_state.dart';
import 'package:popular_movie/features/movies/cubit/favourite_movie_cubit.dart';
import 'package:popular_movie/features/movies/cubit/fetch_all_favourite_cubit.dart';
import 'package:popular_movie/features/movies/cubit/fetch_movie_list_bloc.dart';
import 'package:popular_movie/features/movies/cubit/movie_event.dart';
import 'package:popular_movie/features/movies/models/movie_model.dart';
import 'package:popular_movie/features/movies/ui/pages/movie_details.dart';

class MovieCard extends StatefulWidget {
  final MovieModel movie;
  const MovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: widget.movie),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.movie.posterImage,
              fit: BoxFit.cover,
              height: 240,
              width: double.infinity,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.movie.title,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: BlocConsumer<FavoriteCubit, CommonState>(
                  listener: (context, state) {
                    if (state is CommonSuccessState<bool>) {
                      if (state.item != widget.movie.favorite) {
                        context
                            .read<FetchMovieListBloc>()
                            .add(ReloadMovieEvent());
                        context.read<FetchAllFavoriteCubit>().reload();
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is CommonSuccessState<bool>) {
                      return IconButton(
                        onPressed: () {
                          if (widget.movie.favorite) {
                            context
                                .read<FavoriteCubit>()
                                .unfavorite(widget.movie.id);
                          } else {
                            context
                                .read<FavoriteCubit>()
                                .favorite(widget.movie);
                          }
                        },
                        icon: Icon(
                          widget.movie.favorite
                              ? Icons.favorite_outlined
                              : Icons.favorite_outline_outlined,
                        ),
                      );
                    } else {
                      return const CupertinoActivityIndicator();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
