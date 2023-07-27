import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popular_movie/features/cubit/fetch_all_favourite_cubit.dart';
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
    final textTheme = Theme.of(context).textTheme;
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
          BlocProvider(
            create: (context) => FetchAllFavoriteCubit(
              repository: context.read<MovieRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie',
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
              bodyMedium: GoogleFonts.lato(
                  textStyle: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
          home: const MovieScreen(),
        ),
      ),
    );
  }
}
