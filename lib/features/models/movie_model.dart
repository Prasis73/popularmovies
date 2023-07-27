import 'dart:convert';

class MovieModel {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  String voteAverage;
  int voteCount;
  MovieModel({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "adult": adult,
      "backdrop_path": backdropPath,
      "genre_ids": genreIds,
      "id": id,
      "original_language": originalLanguage,
      "original_title": originalTitle,
      "overview": overview,
      "popularity": popularity,
      "poster_path": posterPath,
      "release_date": releaseDate,
      "title": title,
      "video": video,
      "vote_average": voteAverage.toString(),
      "vote_count": voteCount,
    };
  }

  factory MovieModel.fromMap(Map<String, dynamic> json) {
    return MovieModel(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] ?? "",
      genreIds: List.from(json["genre_ids"] ?? [])
          .map((e) => int.parse(e.toString()))
          .toList(),
      id: json["id"],
      originalLanguage: json["original_language"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      popularity: json["popularity"] ?? 0,
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"] ?? "",
      title: json["title"] ?? "",
      video: json["video"] ?? false,
      voteAverage: json["vote_average"]?.toString() ?? "",
      voteCount: json["vote_count"] ?? 0,
    );
  }

  String get posterImage => "https://image.tmdb.org/t/p/w500/$posterPath";

  String toJson() => json.encode(toMap());

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
