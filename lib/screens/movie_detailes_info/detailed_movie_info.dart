import 'dart:ui';
import 'package:flutter/material.dart';

import '../../providers/movie.dart';
import '../../models/media_models/details_media_mod.dart';
import '../../widgets/detailed_widget/get_image.dart';
import '../../widgets/system_widgets/error_message_widg.dart';
import '../../widgets/detailed_widget/movie_details_column.dart';
import '../../widgets/detailed_widget/play_video_button.dart';

//класс с подробным описанием медиа (фильма или сериала)
class DetailedInfoScreen extends StatefulWidget {
  //принимает фильм и тэг для анимированного перехода
  final MediaBasicInfo movie;
  final String heroTag;
  const DetailedInfoScreen({
    required this.movie,
    required this.heroTag,
    Key? key,
  }) : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfoScreen> createState() => _DetailedInfoScreenState();
}

class _DetailedInfoScreenState extends State<DetailedInfoScreen> {
  //флаг для отслеживания загрузки данных
  var _isLoading = false;
  //базовые данные о фильме
  MediaBasicInfo? _movie;
  //детальные данные о фильме
  DetailsMediaMod? _details;
  var _isError = false;
  bool _isClick = false;

  //инициализируем данные о фильме
  @override
  void initState() {
    _movie = widget.movie;
    //получение детальных данных о фильме
    _details = DetailsMediaMod(
      _movie?.id ?? 0,
      _movie?.date ?? '',
    );
    super.initState();
  }

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    setState(() => _isLoading = true);

    //проверяем, избранные это фильм или нет, для правильного отображения иконки
    _movie!.isfavorte().then((value) {
      _movie!.status = value;

      //если тип медиа Фильм, то инициализируем данные, как у фильма
      if (_movie!.type == MediaType.movie) {
        _inizMovie();
      }

      //если тип медиа TV, то инициализируем сериал
      else {
        _inizTVShow();
      }
    });

    super.didChangeDependencies();
  }

  // метод для инициализации подробных данных о фильме
  _inizMovie() async {
    try {
      setState(() => _isError = false);

      if (_details != null) {
        //сперва получаем детальные данные о фильме, они нужны для остальных запросов
        await _details!.getDetailesMovie();

        //делаем все запросы синхронно
        Future.wait([
          _details!.getRating(),
          _details!.getMovieCredits(),
          _details!.getTrailer(_movie!.type),
          _details!.getWatchProviders(_movie!.type),
        ]).then((_) {
          //если экран закрыт уже, то метод закрываем
          if (!mounted) return;

          //если нет, то прекращаем загрузку
          setState(() => _isLoading = false);
        });
      }
    } catch (error) {
      setState(() => _isError = true);
    }
  }

  //методя для инициализации подробных данных о сериале
  _inizTVShow() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      if (_details != null) {
        //сперва получаем детальные данные о сериале, они нужны для остальных запросов
        await _details!.getDetailesTVShow();

        //делаем все запросы синхронно
        Future.wait([
          _details!.getRating(),
          _details!.getTVShowCredits(),
          _details!.getTrailer(_movie!.type),
          _details!.getWatchProviders(_movie!.type),
        ]).then((_) {
          if (!mounted) return;
          setState(() => _isLoading = false);
        });
      }
    } catch (error) {
      setState(() => _isError = true);
    }
  }

  //метод для изменения статуса медиа
  void _likeStatus() {
    _isClick = !_isClick;
    setState(() {
      _movie?.toogleStatus();
    });
  }

  //метод для получения изображения для постера
  ImageProvider getImage(String? imageUrl) {
    if (imageUrl!.contains('noImageFound')) {
      return AssetImage(imageUrl);
    } else {
      return NetworkImage('https://image.tmdb.org/t/p/w300$imageUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _myHeight = MediaQuery.of(context).size.height;
    final _myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        //ошибка загрузки
        body: _isError
            ? ErrorMessageWidget(
                handler: _inizMovie,
                size: MediaQuery.of(context).size,
              )
            : Stack(
                children: [
                  SizedBox(
                    height: _myHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        //размытый постер
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: 10.0,
                            sigmaY: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: getImage(widget.movie.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        //постер на переднем плане, подключаем анимацию -
                        //для плавного изменеия размеров и положения виджета
                        Positioned(
                          bottom: 180,
                          child: GestureDetector(
                            onDoubleTap: (() {
                              _likeStatus();
                            }),
                            child: Hero(
                              transitionOnUserGestures: true,
                              tag: widget.heroTag,
                              child: GetImage(
                                imageUrl: widget.movie.imageUrl,
                                title: widget.movie.title,
                                height: _myHeight * 0.6,
                                width: _myWidth * 0.8,
                                titleFontSize: 25,
                              ),
                            ),
                          ),
                        ),

                        //кнопка "назад"
                        Positioned(
                          top: 10,
                          left: 8,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromARGB(66, 12, 12, 12),
                            child: IconButton(
                              onPressed: () {
                                _isClick
                                    ? Navigator.pop(context, true)
                                    : Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        //кнопка "добавить в любимые фильмы"
                        _isLoading
                            ? const SizedBox()
                            : Positioned(
                                top: 10,
                                right: 8,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Color.fromARGB(66, 12, 12, 12),
                                  child: IconButton(
                                    onPressed: () {
                                      _likeStatus();
                                    },
                                    icon: _movie!.status
                                        ? const Icon(
                                            Icons.favorite,
                                            size: 30,
                                            color: Colors.white,
                                          )
                                        : const Icon(Icons.favorite_border,
                                            size: 33, color: Colors.white),
                                  ),
                                ),
                              ),

                        // кнопка для воспроизведения видео трейлера
                        _isLoading
                            ? const SizedBox()
                            : PlayVideoButton(
                                keyVideo: _details?.keyVideo ?? '')
                      ],
                    ),
                  ),

                  // расширяющийся список
                  DraggableScrollableSheet(
                    initialChildSize: 0.18,
                    maxChildSize: 1,
                    minChildSize: 0.18,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Opacity(
                        opacity: 0.95,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    //Название фильма на русском
                                    Text(
                                      '${widget.movie.title}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),

                                    //название фильма на языке оригинала
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        '${widget.movie.originalTitle}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    _isLoading

                                        // пока загружаем, показываем загрузочный спиннер
                                        ? Container(
                                            alignment: Alignment.topCenter,
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onInverseSurface),
                                          )

                                        //выводим детальные данные о фильме
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            child: MovieDetailsColumn(
                                              details: _details,
                                              myHeight: _myHeight,
                                              media: _movie,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
