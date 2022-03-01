import 'dart:ui';
import 'package:flutter/material.dart';

import '../providers/movie.dart';
import '../widgets/detailed_widget/videoPlayer.dart';
import '../widgets/error_message_widg.dart';
import '../widgets/detailed_widget/movie_details_column.dart';

//класс с подробным описанием фильма
class DetailedInfo extends StatefulWidget {
  final Movie movie;
  final String heroTag;
  final Image image;
  const DetailedInfo(
      {required this.movie,
      required this.heroTag,
      required this.image,
      Key? key})
      : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  var _isLoading = false;
  Movie? _movie;
  var _isError = false;

  @override
  void initState() {
    _movie = widget.movie;
    super.initState();
  }

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    // _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    _iniz();
    super.didChangeDependencies();
  }

  // метод для запуска запросов
  // после завершения запроса о деталях фильма, делаем запрос о рейтинге фильма
  _iniz() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
      if (_movie != null) {
        await _movie!.detailedMovie().then(
              (_) => {
                _movie!.getRating(),
                _movie!.getTrailer(),
                _movie!.getMovieCredits()
              },
            );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Поймана ошибка $error');
      setState(() {
        _isError = true;
      });
    }
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
                handler: _iniz,
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
                          bottom: 170,
                          child: SizedBox(
                            width: _myWidth * 0.75,
                            height: _myHeight * 0.5,
                            child: Hero(
                              tag: widget.heroTag,
                              child: widget.image,
                            ),
                          ),
                        ),

                        //кнопка "назад"
                        Positioned(
                          top: 10,
                          left: 8,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_outlined,
                              size: 35,
                            ),
                          ),
                        ),

                        // кнопка для воспроизведения видео трейлера
                        _isLoading ? SizedBox() : playVideoButton(context),
                      ],
                    ),
                  ),

                  // расширяющийся список
                  DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    maxChildSize: 1,
                    minChildSize: 0.20,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Opacity(
                        opacity: 0.96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.black,
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    //Название фильма на русском
                                    Text(
                                      '${widget.movie.title}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    //название фильма на языке оригинала
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        '${widget.movie.originalTitle}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: MovieDetailsColumn(
                                                movie: _movie,
                                                myHeight: _myHeight),
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
      right: 65,
      bottom: 180,
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
            _movie!.keyVideo.isNotEmpty
                ? Navigator.pushNamed(
                    context,
                    VideoPlayerScreen.routNamed,
                    arguments: _movie,
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
