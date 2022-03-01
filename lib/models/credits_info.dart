import 'dart:convert';

import 'package:flutter/material.dart';

//Модель для получения Json результата запроса об актерах и съемочной групее фильма
CreditsMovieInfo welcomeFromJson(String str) =>
    CreditsMovieInfo.fromJson(json.decode(str));

String welcomeToJson(CreditsMovieInfo data) => json.encode(data.toJson());

class CreditsMovieInfo {
  CreditsMovieInfo({
    required this.id,
    required this.cast,
    required this.crew,
  });

  int id;
  List<Cast> cast;
  List<Cast> crew;
  //список самых важных работников съемочной группы
  //для вывода на общем экране фильма
  List<Cast> customCrewList = [];
  //карта со списком должностей и людей на должности
  Map<String, List<Cast>> custumCrewMap = {};

  factory CreditsMovieInfo.fromJson(Map<String, dynamic> json) =>
      CreditsMovieInfo(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };

// метод для фильтрации съемочной группы,
// в зависимости от их должности
  List<Cast> getCrewList(List<String> jobList) {
    List<Cast> listCrew = [];

    for (int j = 0; j < jobList.length; j++) {
      for (int i = 0; i < crew.length; i++) {
        final crewPers = crew[i];
        if (jobList[j] == crewPers.job) {
          listCrew.add(crewPers);
          customCrewList.add(crewPers);
        }
      }
    }
    return listCrew;
  }

//метод для фильтрации списка съемочной группы
  void createMapCrew() {
    custumCrewMap = {
      'Режиссер': getCrewList(['Director']),
      'Продюссер':
          getCrewList(['Producer', 'Executive Producer', 'Associate Producer']),
      'Сценарист': getCrewList(['Screenplay', 'Novel']),
      'Оператор': getCrewList(['Director of Photography']),
      'Композитор': getCrewList(['Original Music Composer']),
      'Художник-постановщик': getCrewList(['Production Design']),
      'Художник-костюмер': getCrewList(['Costume Design']),
      'Арт-директор': getCrewList(['Art Direction']),
      'Монтажер': getCrewList(['Editor']),
    };
  }
}

class Cast {
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
    required this.department,
    required this.job,
  });

  bool adult;
  int gender;
  int id;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  int? castId;
  String? character;
  String creditId;
  int? order;
  Department? department;
  String? job;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        gender: json["gender"],
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"] == null ? null : json["profile_path"],
        castId: json["cast_id"] == null ? null : json["cast_id"],
        character: json["character"] == null ? null : json["character"],
        creditId: json["credit_id"],
        order: json["order"] == null ? null : json["order"],
        department: json["department"] == null
            ? null
            : departmentValues.map[json["department"]],
        job: json["job"] == null ? null : json["job"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath == null ? null : profilePath,
        "cast_id": castId == null ? null : castId,
        "character": character == null ? null : character,
        "credit_id": creditId,
        "order": order == null ? null : order,
        "department":
            department == null ? null : departmentValues.reverse[department],
        "job": job == null ? null : job,
      };

  //получаем постер, проверяем на null, если постер отсутсвует,
  // то присваиваем пустую фотографию
  ImageProvider getImage() {
    if (profilePath == null) {
      return const AssetImage('assets/image/noImageFound.png');
    } else {
      // print('https://image.tmdb.org/t/p/w185$profilePath');
      return NetworkImage('https://image.tmdb.org/t/p/original$profilePath');
    }
  }
}

enum Department {
  ACTING,
  WRITING,
  CREW,
  VISUAL_EFFECTS,
  DIRECTING,
  PRODUCTION,
  COSTUME_MAKE_UP,
  ART,
  SOUND,
  CAMERA,
  EDITING,
  LIGHTING
}

final departmentValues = EnumValues({
  "Acting": Department.ACTING,
  "Art": Department.ART,
  "Camera": Department.CAMERA,
  "Costume & Make-Up": Department.COSTUME_MAKE_UP,
  "Crew": Department.CREW,
  "Directing": Department.DIRECTING,
  "Editing": Department.EDITING,
  "Lighting": Department.LIGHTING,
  "Production": Department.PRODUCTION,
  "Sound": Department.SOUND,
  "Visual Effects": Department.VISUAL_EFFECTS,
  "Writing": Department.WRITING
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap as Map<T, String>;
  }
}
