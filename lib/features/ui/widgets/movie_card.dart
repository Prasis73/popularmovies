// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:popular_movie/features/models/movie_model.dart';

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
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline_outlined,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
