//модель для обработки API запроса, который возвращает детальную информацию об одном фильме
class MovieInfoRequest {
  MovieInfoRequest({
    required this.genres,
    required this.id,
    required this.imdbId,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.runtime,
    required this.title,
    required this.voteCount,
    required this.releaseDates,
    required this.watchProviders,
  });

  List<Genre>? genres;
  int id;
  String? imdbId;
  String? originalTitle;
  String? overview;
  String? posterPath;
  int runtime;
  String? title;
  int voteCount;
  ReleaseDates releaseDates;
  WatchProviders watchProviders;

  factory MovieInfoRequest.fromJson(Map<String, dynamic> json) =>
      MovieInfoRequest(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        id: json["id"],
        imdbId: json["imdb_id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        runtime: json["runtime"],
        title: json["title"],
        voteCount: json["vote_count"],
        // credits: CreditsMov.fromJson(json["credits"]),
        releaseDates: ReleaseDates.fromJson(json["release_dates"]),
        watchProviders: WatchProviders.fromJson(json["watch/providers"]),
      );

//список трех главных жанра фильма
  String getGenres() {
    String genre = '';
    if (genres != null) {
      for (int i = 0; i < genres!.length; i++) {
        if (i < 3) {
          i == 0 ? genre += genres![i].name : genre += ', ${genres![i].name}';
        } else {
          break;
        }
      }
    }
    return genre;
  }

//возвращаем длительность фильма
  String getDuration() {
    if (runtime > 60) {
      return '${runtime ~/ 60}ч. ${runtime % 60}мин.';
    } else {
      return '$runtime мин.';
    }
  }
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );
}

class ReleaseDates {
  ReleaseDates({
    required this.results,
  });

  List<Result>? results;

  factory ReleaseDates.fromJson(Map<String, dynamic> json) => ReleaseDates(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );
}

class Result {
  Result({
    required this.iso31661,
    required this.releaseDates,
  });

  String? iso31661;
  List<ReleaseDate>? releaseDates;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        iso31661: json["iso_3166_1"],
        releaseDates: List<ReleaseDate>.from(
            json["release_dates"].map((x) => ReleaseDate.fromJson(x))),
      );
}

class ReleaseDate {
  ReleaseDate({
    required this.certification,
  });
  String? certification;
  factory ReleaseDate.fromJson(Map<String, dynamic> json) => ReleaseDate(
        certification: json["certification"],
      );
}

class WatchProviders {
  WatchProviders({
    required this.results,
  });

  Results? results;

  factory WatchProviders.fromJson(Map<String, dynamic> json) => WatchProviders(
        results: Results.fromJson(json["results"]),
      );
}

class Results {
  Results({
    required this.ru,
  });
  Ae ru;

  factory Results.fromJson(Map<String, dynamic>? json) {
    if (json?["RU"] == null) {
      return Results(ru: Ae(link: null, rent: null, buy: null, flatrate: null));
    } else {
      return Results(ru: Ae.fromJson(json?["RU"]));
    }
  }
}

class Ae {
  Ae({
    required this.link,
    required this.rent,
    required this.buy,
    required this.flatrate,
  });

  String? link;
  List<Buy>? rent;
  List<Buy>? buy;
  List<Buy>? flatrate;

  factory Ae.fromJson(Map<String, dynamic>? json) => Ae(
        link: json?["link"],
        rent: json?['rent'] == null
            ? null
            : List<Buy>.from(json!["rent"].map((x) => Buy.fromJson(x))),
        buy: json?["buy"] == null
            ? null
            : List<Buy>.from(json!["buy"].map((x) => Buy.fromJson(x))),
        flatrate: json?["flatrate"] == null
            ? null
            : List<Buy>.from(json!["flatrate"].map((x) => Buy.fromJson(x))),
      );
}

class Buy {
  Buy({
    required this.logoPath,
    required this.providerName,
  });

  String? logoPath;
  String? providerName;

  factory Buy.fromJson(Map<String, dynamic> json) => Buy(
        logoPath: json["logo_path"],
        providerName: json["provider_name"],
      );
}
