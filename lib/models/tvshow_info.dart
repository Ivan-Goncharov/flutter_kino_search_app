import 'package:flutter/material.dart';

// класс для обработки json результата запроса детальной информации
class TvShowDetailsInfo {
  TvShowDetailsInfo({
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.lastAirDate,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.voteCount,
    required this.watchProviders,
    required this.externalIds,
  });

  List<int>? episodeRunTime;
  String? firstAirDate;
  List<Genre>? genres;
  String? lastAirDate;
  String? name;
  dynamic nextEpisodeToAir;
  int numberOfEpisodes;
  int numberOfSeasons;
  String? originalName;
  String? overview;
  String? posterPath;
  int voteCount;
  WatchProviders? watchProviders;
  ExternalIds? externalIds;

  factory TvShowDetailsInfo.fromJson(Map<String, dynamic> json) =>
      TvShowDetailsInfo(
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: json["first_air_date"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        lastAirDate: json["last_air_date"],
        name: json["name"],
        nextEpisodeToAir: json["next_episode_to_air"],
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originalName: json["original_name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        voteCount: json["vote_count"],
        watchProviders: WatchProviders.fromJson(json["watch/providers"]),
        externalIds: ExternalIds.fromJson(json["external_ids"]),
      );

  String getGenres() {
    String genre = '';
    if (genres != null) {
      for (int i = 0; i < genres!.length; i++) {
        if (i < 3) {
          i == 0
              ? genre += '${genres![i].name}'
              : genre += ', ${genres![i].name}';
        } else {
          break;
        }
      }
    }
    return genre;
  }

  //возвращаем длительность фильма
  String getDuration() {
    final runtime = episodeRunTime?[0] ?? 0;
    if (runtime > 60) {
      return '${runtime ~/ 60}ч. ${runtime % 60}мин.';
    } else if (runtime % 60 == 0) {
      return '${runtime ~/ 60}ч.';
    } else {
      return '$runtime мин.';
    }
  }

  String getLastEpisodeDate() {
    String date = lastAirDate ?? '';
    if (date != '' && date.length > 3) {
      return date.substring(0, 4);
    } else {
      return '';
    }
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

class ExternalIds {
  ExternalIds({
    required this.imdbId,
  });

  String? imdbId;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
        imdbId: json["imdb_id"],
      );
}

class WatchProviders {
  WatchProviders({
    required this.results,
  });
  Results results;
  factory WatchProviders.fromJson(Map<String, dynamic> json) => WatchProviders(
        results: Results.fromJson(json["results"]),
      );
}

class Results {
  Results({
    required this.ru,
  });
  At ru;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        ru: At.fromJson(json["RU"]),
      );
}

class Flatrate {
  Flatrate({
    required this.logoPath,
    required this.providerName,
  });

  String? logoPath;
  String? providerName;

  factory Flatrate.fromJson(Map<String, dynamic> json) => Flatrate(
        logoPath: json["logo_path"],
        providerName: json["provider_name"],
      );
}

class At {
  At({
    required this.link,
    required this.flatrate,
    required this.buy,
    required this.rent,
  });

  String? link;
  List<Flatrate>? flatrate;
  List<Flatrate>? buy;
  List<Flatrate>? rent;

  factory At.fromJson(Map<String, dynamic> json) => At(
        link: json["link"],
        flatrate: List<Flatrate>.from(
            json["flatrate"].map((x) => Flatrate.fromJson(x))),
        buy: json["buy"] == null
            ? null
            : List<Flatrate>.from(json["buy"].map((x) => Flatrate.fromJson(x))),
        rent: json["rent"] == null
            ? null
            : List<Flatrate>.from(
                json["rent"].map((x) => Flatrate.fromJson(x))),
      );
}
