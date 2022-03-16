//класс для обработки поиска сериалов
class SearchTVShowModel {
  SearchTVShowModel({
    required this.page,
    required this.results,
  });

  int page;
  List<Result> results;

  factory SearchTVShowModel.fromJson(Map<String, dynamic> json) =>
      SearchTVShowModel(
        page: json["page"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteCount,
  });

  String? firstAirDate;
  List<int> genreIds;
  int id;
  String? name;
  String? originalName;
  String? overview;
  String? posterPath;
  int voteCount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        firstAirDate: (json["first_air_date"]),
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        voteCount: json["vote_count"],
      );
}
