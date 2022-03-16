//Класс для обработки поиска фильмов в Json формат
class SearchMovie {
  SearchMovie({
    required this.page,
    required this.results,
  });

  int page;
  List<Result> results;

  factory SearchMovie.fromJson(Map<String, dynamic> json) => SearchMovie(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteCount,
  });

  List<int> genreIds;
  int id;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? releaseDate;
  String? title;
  int voteCount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        voteCount: json["vote_count"],
      );
}
