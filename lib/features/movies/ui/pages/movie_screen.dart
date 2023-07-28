import 'package:flutter/material.dart';
import 'package:popular_movie/features/movies/ui/widgets/movie_widget.dart';


class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    return const MovieWidget();
  }
}
