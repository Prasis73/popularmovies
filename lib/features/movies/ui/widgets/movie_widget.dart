import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/common/cubit/common_state.dart';
import 'package:popular_movie/features/movies/cubit/favourite_movie_cubit.dart';
import 'package:popular_movie/features/movies/cubit/fetch_movie_list_bloc.dart';
import 'package:popular_movie/features/movies/cubit/movie_event.dart';
import 'package:popular_movie/features/movies/models/movie_model.dart';
import 'package:popular_movie/features/movies/resources/movie_repository.dart';
import 'package:popular_movie/features/movies/ui/pages/favourite_screen.dart';
import 'package:popular_movie/features/movies/ui/widgets/movie_card.dart';

class MovieWidget extends StatefulWidget {
  const MovieWidget({super.key});

  @override
  State<MovieWidget> createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<FetchMovieListBloc>().add(FetchMovieEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 238, 238),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Popular Movies"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouriteScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            top: 20), // add padding to adjust text
                        isDense: true,
                        hintText: "    Search Popular Movies ..",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        context.read<FetchMovieListBloc>().add(
                              FetchMovieEvent(
                                query: _searchController.text,
                              ),
                            );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height: 37,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            context.read<FetchMovieListBloc>().add(
                                  FetchMovieEvent(
                                    query: _searchController.text,
                                  ),
                                );
                          },
                          child: const Center(
                              child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ))),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<FetchMovieListBloc, CommonState>(
                buildWhen: (previous, current) {
                  if (current is CommonLoadingState) {
                    return current.showLoading;
                  } else {
                    return true;
                  }
                },
                builder: (context, state) {
                  if (state is CommonErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is CommonSuccessState<List<MovieModel>>) {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.pixels >=
                                (notification.metrics.maxScrollExtent / 2) &&
                            _controller.position.userScrollDirection ==
                                ScrollDirection.reverse) {
                          context.read<FetchMovieListBloc>().add(
                              LoadMoreMovieEvent(
                                  query: _searchController.text));
                        }
                        return true;
                      },
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: _controller,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
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
                              initialValue: state.item[index].favorite,
                            ),
                            child: MovieCard(movie: state.item[index]),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
