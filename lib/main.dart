import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movie/features/resources/movie_repository.dart';

import 'common/api/api_provider.dart';
import 'common/services/database_services.dart';
import 'features/cubit/fetch_movie_list_bloc.dart';
import 'features/ui/pages/movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ApiProvider(),
        ),
        RepositoryProvider(
          create: (context) => DatabaseService(),
        ),
        RepositoryProvider(
          create: (context) => MovieRepository(
            apiProvider: context.read<ApiProvider>(),
            databaseService: context.read<DatabaseService>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FetchMovieListBloc(
              repository: context.read<MovieRepository>(),
            ),
          ),
        ],
        child: const MaterialApp(
          title: 'Movie',
          home: MovieScreen(),
        ),
      ),
    );
  }
}
