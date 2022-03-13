// ignore_for_file: avoid_print
import 'dart:ui';
import 'package:flutter/material.dart';

import '../../models/details_media_mod.dart';
import '../../widgets/detailed_widget/get_image.dart';
import '../../providers/movie.dart';
import '../../widgets/detailed_widget/videoPlayer.dart';
import '../../widgets/error_message_widg.dart';
import '../../widgets/detailed_widget/movie_details_column.dart';

//класс с подробным описанием фильма
class DetailedInfoScreen extends StatefulWidget {
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
  var _isLoading = false;
  MediaBasicInfo? _movie;
  DetailsMediaMod? _details;
  var _isError = false;
  bool _isClick = false;

  @override
  void initState() {
    _movie = widget.movie;
    _details = DetailsMediaMod(
      _movie?.id ?? 0,
      _movie?.date ?? '',
    );
    super.initState();
  }

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    _movie!.isfavorte().then((value) {
      _movie!.status = value;
      if (_movie!.type == MediaType.movie) {
        _inizMovie();
      }
      if (_movie!.type == MediaType.tvShow) {
        _inizTVShow();
      }
    });

    super.didChangeDependencies();
  }

  // метод для инициализации подробных данных о фильме
  _inizMovie() async {
    try {
      setState(() {
        _isError = false;
      });

      if (_details != null) {
        _details!.getDetailesMovie();
        await Future.wait([
          _details!.getRating(),
          _details!.getMovieCredits(),
          _details!.getTrailer(_movie!.type),
          _details!.getWatchProviders(_movie!.type),
        ]).then((_) {
          if (!mounted) return;
          setState(() => _isLoading = false);
        });
      }
    } catch (error) {
      print('ошибка в _inizMovie/detaled movie $error');
      setState(() {
        _isError = true;
      });
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
        _movie!.isfavorte().then((value) => _movie!.status = value);
        _details!.getDetailesTVShow();
        await Future.wait([
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
      print('ошибка в _inizMovie/detaled movie $error');
      if (!mounted) return;
      setState(() {
        _isError = true;
      });
    }
  }

  void _likeStatus() {
    _isClick = !_isClick;
    setState(() {
      _movie?.toogleStatus();
    });
  }

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
        body: _isError
            ? ErrorMessageWidget(
                handler: _inizMovie,
                size: MediaQuery.of(context).size,
              )
            : Stack(
                children: [
                  SizedBox(
                    height: _myHeight * 0.85,
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
                          bottom: 110,
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
                            : playVideoButton(context),
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
                        opacity: 0.96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
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
                                            child:
                                                const CircularProgressIndicator(
                                                    color: Colors.white38),
                                          )
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

// Кнопка для воспроизведения видео трейлера
  Positioned playVideoButton(BuildContext context) {
    return Positioned(
      right: 55,
      bottom: 125,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: const Color.fromARGB(255, 71, 70, 70),
        child: IconButton(
          icon: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            _details!.keyVideo.isNotEmpty
                ? Navigator.pushNamed(
                    context,
                    VideoPlayerScreen.routNamed,
                    arguments: _details?.keyVideo ?? '',
                  )
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text(
                          'Ошибка',
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'Приносим наши извинения, видео не нашлось',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
