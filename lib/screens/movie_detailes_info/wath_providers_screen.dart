import 'package:flutter/material.dart';

import '../../providers/movie.dart';
import '../../models/media_models/details_media_mod.dart';
import '../../widgets/system_widgets/tmdb_icon.dart';
import '../../widgets/detailed_widget/item_type_provider.dart';

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

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });

    //принимаем аргументы через навигатор
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
    //получаем видео поставщиков из России
    final watchProv = _details!.watchProviders!.results.ru;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _isLoading
            ? Center(
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                    Text('Загружаем информацию'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //кнопка "Назад"
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        size: 35,
                      ),
                    ),

                    //выводим списки провайдеров для фильма
                    Container(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //заголовок
                          WatchNowTitle(),
                          // если нет информации по подпискам, то не выводим
                          watchProv?.flatrate == null
                              ? const SizedBox()
                              // инфа о сервисах, где доступно видео по подписке
                              : ItemTypeSupplier(
                                  title: 'По подписке',
                                  supplier: watchProv?.flatrate ?? [],
                                  movieTitle: _media?.title ?? '',
                                  originalTitle: _media?.originalTitle ?? '',
                                ),

                          // если нет информации по аренде, то не выводим
                          watchProv?.rent == null
                              ? const SizedBox()
                              // инфа о сервисах, где доступно видео по аренде
                              : ItemTypeSupplier(
                                  title: 'Аренда',
                                  supplier: watchProv?.rent ?? [],
                                  movieTitle: _media?.title ?? '',
                                  originalTitle: _media?.originalTitle ?? '',
                                ),

                          // если нет информации по аренде, то не выводим
                          watchProv?.buy == null
                              ? const SizedBox()
                              // инфа о сервисах, где доступно видео по аренде
                              : ItemTypeSupplier(
                                  title: 'Покупка',
                                  supplier: watchProv?.buy ?? [],
                                  movieTitle: _media?.title ?? '',
                                  originalTitle: _media?.originalTitle ?? '',
                                ),

                          watchProv?.link == null
                              ? const SizedBox()
                              // ссылка на информацию на tmdb
                              : Padding(
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
}

//заголовок - информация о том, кем предоставлена информация
class WatchNowTitle extends StatelessWidget {
  const WatchNowTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Cмотреть сейчас',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
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
    );
  }
}
