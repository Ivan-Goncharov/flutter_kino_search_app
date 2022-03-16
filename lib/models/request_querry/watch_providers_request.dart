//Данная модель обрабатывает данные,
//полученные после API запроса по доступным провайдерам
class WatchProvidersRequest {
  WatchProvidersRequest({
    required this.results,
  });
  Results results;
  factory WatchProvidersRequest.fromJson(Map<String, dynamic> json) =>
      WatchProvidersRequest(
        results: Results.fromJson(json["results"]),
      );
}

class Results {
  Results({
    required this.ru,
  });
  At? ru;

  factory Results.fromJson(Map<String, dynamic>? json) => Results(
        ru: json?["RU"] == null ? null : At.fromJson(json!["RU"]),
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
        flatrate: json["flatrate"] == null
            ? null
            : List<Flatrate>.from(
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
