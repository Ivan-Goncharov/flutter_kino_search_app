import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/request_querry/watch_providers_request.dart';

//виджет для вывода одного типа просмотра
// по подписке, аренда, покупка
class ItemTypeSupplier extends StatelessWidget {
  //заголовок
  final String title;
  //список провадйеров
  final List<Flatrate> supplier;
  //название фильма
  final String movieTitle;
  //оригинальное название фильма
  final String originalTitle;

  const ItemTypeSupplier(
      {Key? key,
      required this.title,
      required this.supplier,
      required this.movieTitle,
      required this.originalTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
          ListSupplier(
            listOfSupplier: supplier,
            movieTitle: movieTitle,
            originalTitle: originalTitle,
          ),
        ],
      ),
    );
  }
}

//виджет для вывода поставщиков и ссылок на на фильмы
class ListSupplier extends StatelessWidget {
  //список поставщиков
  final List<Flatrate> listOfSupplier;
  //название фильма
  final String movieTitle;
  //оригинальное название фильма
  final String originalTitle;

  const ListSupplier(
      {Key? key,
      required this.listOfSupplier,
      required this.movieTitle,
      required this.originalTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              // переходим по тапу на изображение на ссылку с провайдером
              child: GestureDetector(
                onTap: () {
                  print(
                    _getMediaLink('${listOfSupplier[index].providerName}',
                        '$movieTitle', '$originalTitle'),
                  );
                  _launchURLBrowser(
                    _getMediaLink('${listOfSupplier[index].providerName}',
                        '$movieTitle', '$originalTitle'),
                  );
                },
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/original${listOfSupplier[index].logoPath}'),
                ),
              ),
            ),
          );
        },
        itemCount: listOfSupplier.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }

  // метод для определния провайдера и подбора ссылки для конкретного провайдера
  String _getMediaLink(
    String providerName,
    String mediaRusName,
    String mediaOrigName,
  ) {
    String linkOkko = '';
    final lowerName = mediaOrigName.toLowerCase();
    final words = lowerName.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (i == 0) {
        linkOkko += words[i];
      } else {
        linkOkko += '-${words[i]}';
      }
    }

    switch (providerName) {
      case 'Ivi':
        return 'https://www.ivi.tv';

      case 'Kinopoisk':
        return 'https://www.kinopoisk.ru/index.php?kp_query=${Uri.encodeFull(mediaRusName)}';

      case 'Wink':
        return 'https://wink.ru/search?query=${Uri.encodeFull(mediaRusName)}';

      case 'Google Play Movies':
        return 'https://play.google.com/store/search?q=${Uri.encodeFull(mediaRusName)}&c=movies&hl=ru&gl=RU';

      case 'Okko':
        return 'https://okko.tv/serial/${Uri.encodeFull(linkOkko)}';

      case 'Netflix':
        return 'https://www.netflix.com/ru/';

      case 'Apple iTunes':
        return 'https://tv.apple.com/ru';

      case 'Amediateka':
        return 'https://www.amediateka.ru';

      case 'More TV':
        return 'https://more.tv';

      case 'YouTube Premium':
        return 'https://www.youtube.com';

      case 'TvIgle':
        return 'https://www.tvigle.ru';

      case 'Premier':
        return 'https://premier.one/search?query=${Uri.encodeFull(mediaRusName)}';

      default:
        return '';
    }
  }

  // метод для перехода по ссылкам
  Future<void> _launchURLBrowser(String urlAdress) async {
    final url = urlAdress;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
