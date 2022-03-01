import 'package:flutter/material.dart';

import '../../providers/movie.dart';
import '../../screens/full_movie_descrip.dart';
import '../ratings.dart';
import 'actor_cast.dart';
import 'crew_cast.dart';
import 'videoPlayer.dart';

//Виджет для отображения подробной информации о фильме
class MovieDetailsColumn extends StatelessWidget {
  const MovieDetailsColumn({
    Key? key,
    required Movie? movie,
    required double myHeight,
  })  : _movie = movie,
        _myHeight = myHeight,
        super(key: key);

  final Movie? _movie;
  final double _myHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Название фильма на русском
        Text(
          '${_movie!.title}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        //название фильма на языке оригинала
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${_movie!.originalTitle}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        // информация о жанрах и годе производства
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            '${_movie!.date}' + _movie!.genres,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white38),
          ),
        ),
        // длительность фильма
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            _movie!.duration,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white38),
          ),
        ),
        //описание фильма
        Container(
          width: double.infinity,
          height: _myHeight * 0.15,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${_movie!.overview}',
            textAlign: TextAlign.start,
            overflow: TextOverflow.fade,
            style: const TextStyle(fontWeight: FontWeight.w400, height: 1.4),
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
          child: Ratings(_movie!.imdbRat, _movie!.imdbVotes),
        ),

        //кнопка перехода на экран с видео
        createPlayVideoButton(context),

        //горизонтальный скроллинг список актеров
        ActorCast(
          height: _myHeight,
          creditsInfo: _movie!.creditsInfo,
        ),

        //горизонтальный скроллинг список съемочной группы
        CrewCast(
          height: _myHeight,
          creditsInfo: _movie!.creditsInfo,
        ),
      ],
    );
  }

  //кнопка для перехода на страницу с видео
  Container createPlayVideoButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Трейлер',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              // при нажатии проверяем, есть ли youtube Key,
              //если нет, то выводим ошибку
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    'Смотреть',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
