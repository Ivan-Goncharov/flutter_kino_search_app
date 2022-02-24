import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movie.dart';
import 'package:flutter_my_kino_app/widgets/error_message_widg.dart';
import 'package:flutter_my_kino_app/widgets/videoPlayer.dart';

import '../widgets/ratings.dart';
import './full_movie_descrip.dart';

//класс с подробным описанием фильма
class DetailedInfo extends StatefulWidget {
  const DetailedInfo({Key? key}) : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  var _isLoading = false;
  late final Movie _movie;
  var _isError = false;

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    _iniz();
    super.didChangeDependencies();
  }

  // метод для запуска запросов
  // после завершения запроса о деталях фильма, делаем запрос о рейтинге фильма
  _iniz() async {
    try {
      setState(() {
        _isLoading = true;
        // _isError = false;
      });
      await _movie.detailedMovie().then(
            (_) => {
              _movie.getRating(),
              _movie.getTrailer(),
            },
          );

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

  @override
  Widget build(BuildContext context) {
    final _myHeight = MediaQuery.of(context).size.height;
    final _myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_movie.title}'),
      ),
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
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original${_movie.imageUrl}'),
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
                              tag: 'hero_poster',
                              child: Image.network(
                                  'https://image.tmdb.org/t/p/original${_movie.imageUrl}'),
                            ),
                          )),
                    ],
                  ),
                ),

                // расширяющийся список
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : DraggableScrollableSheet(
                        initialChildSize: 0.25,
                        maxChildSize: 1,
                        minChildSize: 0.20,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Opacity(
                            opacity: 0.90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                color: Colors.black,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        //Название фильма на русском
                                        Text(
                                          '${_movie.title}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        //название фильма на языке оригинала
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            '${_movie.originalTitle}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        // информация о жанрах и годе производства
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            '${_movie.date}' + _movie.genres,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white38),
                                          ),
                                        ),
                                        // длительность фильма
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            _movie.duration,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white38),
                                          ),
                                        ),
                                        //описание фильма
                                        Container(
                                          width: double.infinity,
                                          height: _myHeight * 0.15,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${_movie.overview}',
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                height: 1.4),
                                          ),
                                        ),

                                        //кнопка перехода
                                        //на экран с полным описанием фильма
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              FullMovieDesciption.routNamed,
                                              arguments: _movie,
                                            );
                                          },
                                          child: Row(
                                            children: const [
                                              Text('Полное описание'),
                                              Icon(Icons.arrow_right),
                                            ],
                                          ),
                                        ),

                                        //рейтинг фильма и количество оценок
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Ratings(
                                              _movie.imdbRat, _movie.imdbVotes),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Трейлер',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    VideoPlayerScreen.routNamed,
                                                    arguments: _movie,
                                                  );
                                                },
                                                child: Text('Смотреть'),
                                              ),
                                            ],
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
    );
  }
}
