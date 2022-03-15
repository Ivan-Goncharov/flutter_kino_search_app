import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/widgets/tmdb_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/details_media_mod.dart';
import '../../models/watch_providers_request.dart';
import 'package:url_launcher/url_launcher.dart';

// экран для вывода всех возможных вариантов просмотра контента
class WatchProvidersScreen extends StatefulWidget {
  static const routNamed = './watch_providers';
  const WatchProvidersScreen({Key? key}) : super(key: key);

  @override
  State<WatchProvidersScreen> createState() => _WatchProvidersScreenState();
}

class _WatchProvidersScreenState extends State<WatchProvidersScreen> {
  //детали фильма
  DetailsMediaMod? _details;
  MediaBasicInfo? _media;
  var _isLoading = false;

  //запускаем метод для поиска доступных
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _details = arguments['details'];
    _media = arguments['media'];
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final watchProv = _details!.watchProviders!.results.ru;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _isLoading
            ? _getProgressBar()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        size: 35,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Cмотреть сейчас',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // информационное сообщение
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                color: Colors.white54,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text(
                                          'Информация',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          'Cписок предоставлен сайтом TMDB для ознакомления и не содержит прямых медиа-ссылок.',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          // если нет информации по подпискам, то не выводим
                          watchProv?.flatrate == null
                              ? const SizedBox()
                              :
                              // инфа о сервисах, где доступно видео по подписке
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'По подписке',
                                        style: textTheme.displayMedium,
                                        textAlign: TextAlign.start,
                                      ),
                                      getListProvider(
                                          watchProv!.flatrate, height)
                                    ],
                                  ),
                                ),

                          // если нет информации по аренде, то не выводим
                          watchProv?.rent == null
                              ? const SizedBox()
                              :
                              // инфа о сервисах, где доступно видео по аренде
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Аренда',
                                        style: textTheme.displayMedium,
                                        textAlign: TextAlign.start,
                                      ),
                                      getListProvider(watchProv!.rent, height)
                                    ],
                                  ),
                                ),

                          // если нет информации по аренде, то не выводим
                          watchProv?.buy == null
                              ? const SizedBox()
                              :
                              // инфа о сервисах, где доступно видео по аренде
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Покупка',
                                        style: textTheme.displayMedium,
                                        textAlign: TextAlign.start,
                                      ),
                                      getListProvider(watchProv!.buy, height)
                                    ],
                                  ),
                                ),

                          watchProv?.link == null
                              ? const SizedBox()
                              :
                              // ссылка на информацию о ценых
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Информация о ценах',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      TmdbIcon(link: '${watchProv!.link}')
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // вывод одного списка провайдеров по определенному способа показа
  Container getListProvider(List<Flatrate>? list, double myHeight) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      width: double.infinity,
      height: myHeight * 0.12,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              // переходим по тапу на изображение на ссылку с провайдером
              child: GestureDetector(
                onTap: () {
                  _launchURLBrowser(
                    _getMediaLink('${list![index].providerName}',
                        '${_media!.title}', '${_media!.originalTitle}'),
                  );
                },
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/original${list![index].logoPath}'),
                ),
              ),
            ),
          );
        },
        itemCount: list!.length,
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
    // print(providerName);
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
        return 'https://www.ivi.ru/search/?ivi_search=${Uri.encodeFull(mediaOrigName)}';

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
  _launchURLBrowser(String urlAdress) async {
    final url = urlAdress;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // виджет для показа загрузочного экрана
  Center _getProgressBar() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          Text('Загружаем информацию'),
        ],
      ),
    );
  }
}
