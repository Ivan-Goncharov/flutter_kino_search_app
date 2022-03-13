import 'package:flutter/material.dart';

//Модель для получения Json результата запроса об актерах и съемочной групее фильма
class CreditsInfoRequest {
  CreditsInfoRequest({
    // required this.id,
    required this.cast,
    required this.crew,
  });

  // int id;
  List<Cast> cast;
  List<Cast> getCast() {
    cast.sort(
      (a, b) => b.popularity.compareTo(a.popularity),
    );
    return cast;
  }

  List<Cast> crew;
  //список самых важных работников съемочной группы
  //для вывода на общем экране фильма
  List<Cast> customCrewList = [];
  List<Cast> getcustomCrewList() {
    customCrewList.sort(
      (a, b) => b.popularity.compareTo(a.popularity),
    );
    return customCrewList;
  }

  //карта со списком должностей и людей на должности
  Map<String, List<Cast>> custumCrewMap = {};

  factory CreditsInfoRequest.fromJson(Map<String, dynamic> json) =>
      CreditsInfoRequest(
        // id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );

// метод для фильтрации съемочной группы,
// в зависимости от их должности
  List<Cast> getCrewMovieList(List<String> jobList) {
    List<Cast> listCrew = [];

    //если запрос по фильмам
    if (crew[0].jobs == null) {
      for (int j = 0; j < jobList.length; j++) {
        for (int i = 0; i < crew.length; i++) {
          final crewPers = crew[i];

          if (jobList[j] == crewPers.job) {
            listCrew.add(crewPers);
            customCrewList.add(crewPers);
          }
        }
      }
    } else {
      // если запрос по сериалам
      for (int j = 0; j < jobList.length; j++) {
        for (int i = 0; i < crew.length; i++) {
          final crewPers = crew[i];

          if (jobList[j] == crewPers.jobs![0].job) {
            listCrew.add(crewPers);
            customCrewList.add(crewPers);
          }
        }
      }
    }
    listCrew.sort(
      (a, b) => b.popularity.compareTo(a.popularity),
    );
    return listCrew;
  }

//метод для фильтрации списка съемочной группы
  void createMapCrewMovie() {
    custumCrewMap = {
      'Режиссер': getCrewMovieList(['Director']),
      'Продюссер': getCrewMovieList(
          ['Producer', 'Executive Producer', 'Associate Producer']),
      'Сценарист': getCrewMovieList(['Screenplay', 'Novel']),
      'Оператор': getCrewMovieList(['Director of Photography']),
      'Композитор': getCrewMovieList(['Original Music Composer']),
      'Художник-постановщик': getCrewMovieList(['Production Design']),
      'Художник-костюмер': getCrewMovieList(['Costume Design']),
      'Арт-директор': getCrewMovieList(['Art Direction']),
      'Монтажер': getCrewMovieList(['Editor']),
    };
  }
}

class Cast {
  Cast({
    required this.id,
    required this.name,
    required this.originalName,
    required this.profilePath,
    required this.character,
    required this.job,
    required this.roles,
    required this.jobs,
    required this.popularity,
  });

  int id;
  String name;
  String originalName;
  String? profilePath;
  String? character;
  String? job;
  List<RoleTV>? roles;
  double popularity;

  List<JobTV>? jobs;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        profilePath: json["profile_path"],
        character: json["character"],
        job: json["job"],
        roles: json["roles"] == null
            ? null
            : List<RoleTV>.from(json["roles"].map((x) => RoleTV.fromJson(x))),
        jobs: json["jobs"] == null
            ? null
            : List<JobTV>.from(json["jobs"].map((x) => JobTV.fromJson(x))),
        popularity: json["popularity"].toDouble(),
      );

  //получаем постер, проверяем на null, если постер отсутсвует,
  // то присваиваем пустую фотографию
  ImageProvider getImage() {
    if (profilePath == null) {
      return const AssetImage('assets/image/noImageFound.png');
    } else {
      return NetworkImage('https://image.tmdb.org/t/p/original$profilePath');
    }
  }
}

class JobTV {
  JobTV({
    required this.job,
  });

  String? job;

  factory JobTV.fromJson(Map<String, dynamic> json) => JobTV(
        job: json["job"],
      );
}

class RoleTV {
  RoleTV({
    required this.character,
  });
  String? character;

  factory RoleTV.fromJson(Map<String, dynamic> json) => RoleTV(
        character: json["character"],
      );
}
