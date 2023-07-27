// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class MovieEvent {}

class FetchMovieEvent extends MovieEvent {
  final String query;
  FetchMovieEvent({
    this.query = "",
  });
}

class LoadMoreMovieEvent extends MovieEvent {
  final String query;
  LoadMoreMovieEvent({
    this.query = "",
  });
}
