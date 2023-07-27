import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/features/cubit/fetch_all_favourite_cubit.dart';

import '../../../common/cubit/common_state.dart';
import '../../cubit/favourite_movie_cubit.dart';
import '../../cubit/fetch_movie_list_bloc.dart';
import '../../cubit/movie_event.dart';
import '../../models/movie_model.dart';
import '../../resources/movie_repository.dart';
import 'movie_card.dart';

class FavouriteWidget extends StatefulWidget {
  const FavouriteWidget({super.key});

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 238, 238),
      appBar: AppBar(
        title: const Text("Favourites"),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<FetchAllFavoriteCubit, CommonState>(
          builder: (context, state) {
        if (state is CommonErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is CommonSuccessState<List<MovieModel>>) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisExtent: 290,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.item.length,
            itemBuilder: (BuildContext ctx, index) {
              return BlocProvider(
                create: (context) => FavoriteCubit(
                  repository: context.read<MovieRepository>(),
                )..initial(state.item[index].id),
                child: BlocListener<FavoriteCubit, CommonState>(
                  listener: (context, state) {
                    if (state is CommonSuccessState<bool>) {
                      context
                          .read<FetchMovieListBloc>()
                          .add(ReloadMovieEvent());
                    }
                  },
                  child: MovieCard(movie: state.item[index]),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      }),
    );
  }
}
