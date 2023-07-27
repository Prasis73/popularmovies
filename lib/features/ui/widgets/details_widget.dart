// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:popular_movie/features/models/movie_model.dart';

import '../../../common/cubit/common_state.dart';
import '../../cubit/favourite_movie_cubit.dart';
import '../../resources/movie_repository.dart';

class DetailsWidget extends StatelessWidget {
  final MovieModel movie;
  const DetailsWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 238, 238),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 2.1,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    child: Image.network(
                      movie.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  )),
              BlocProvider(
                create: (context) => FavoriteCubit(
                  repository: context.read<MovieRepository>(),
                )..initial(movie.id),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 15),
                        child: Text(
                          movie.title,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    BlocBuilder<FavoriteCubit, CommonState>(
                        builder: (context, state) {
                      if (state is CommonSuccessState<bool>) {
                        return IconButton(
                          onPressed: () {
                            if (state.item) {
                              context
                                  .read<FavoriteCubit>()
                                  .unfavorite(movie.id);
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
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 18),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 143, 129, 4),
                      size: 20,
                    ),
                    Text(
                      "Average Rating:" + movie.voteAverage,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              /*    Padding(
                padding: const EdgeInsets.only(top: 14.0, left: 15),
                child: Text(
                  "Description:",
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ), */
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
                child: Text(
                  movie.overview.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 18, right: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0, top: 5),
                      child: SizedBox(
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.posterImage,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 1),
                          child: Text(
                            "Language: " + movie.originalLanguage.toString(),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 1),
                          child: Text(
                            movie.adult
                                ? "Adult Movie: Yes"
                                : "Adult Movie: No",
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 1),
                          child: Text(
                            "Release Date: " + movie.releaseDate,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(color: Colors.black, blurRadius: 15.0)
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
