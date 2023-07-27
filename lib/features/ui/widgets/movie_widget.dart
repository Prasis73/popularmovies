import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/cubit/common_state.dart';
import '../../cubit/fetch_movie_list_bloc.dart';
import '../../cubit/movie_event.dart';
import '../../models/movie_model.dart';
import 'movie_card.dart';

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
        appBar: AppBar(
          title: const Text("Popular Movies"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                highlightColor: Colors.transparent,
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 20),
                        isDense: true,
                        hintText: "Search",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Icon(Icons.search),
                        ),
                      ),
                      onEditingComplete: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, left: 10),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8)),
                      child: InkWell(
                          onTap: () {},
                          child: const Center(child: Icon(Icons.search))),
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
                    return GridView.builder(
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
                        return MovieCard(movie: state.item[index]);
                      },
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
