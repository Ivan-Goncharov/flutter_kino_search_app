// Класс для обработки запроса о конкретном фильме
class MovieInfo {
  List<Genre> genres;
  int id;
  String? imdbId;
  String? originalTitle;
  String? overview;
  String? posterPath;
  int runtime;
  String? title;
  int voteCount;

  MovieInfo({
    required this.genres,
    required this.id,
    required this.imdbId,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.runtime,
    required this.title,
    required this.voteCount,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) => MovieInfo(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        id: json["id"],
        imdbId: json["imdb_id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        runtime: json["runtime"],
        title: json["title"],
        voteCount: json["vote_count"],
      );

  String getGenres() {
    String genre = '';
    for (int i = 0; i < genres.length; i++) {
      if (i < 3) {
        i == 0 ? genre += '${genres[i].name}' : genre += ', ${genres[i].name}';
      } else {
        break;
      }
    }
    return genre;
  }

  String getDuration() {
    return '${runtime ~/ 60}ч. ${runtime % 60}мин.';
  }
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String? name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
