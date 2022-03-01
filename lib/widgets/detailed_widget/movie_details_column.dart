import 'package:flutter/material.dart';

import '../../providers/movie.dart';
import '../../screens/full_movie_descrip.dart';
import 'ratings.dart';
import 'actor_cast.dart';
import 'crew_cast.dart';

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

  String getDateAndGenre() {
    String text = '';
    if (_movie?.date != null) {
      if (_movie?.genres != null) {
        text = '${_movie!.date}${_movie!.genres}';
      } else {
        text = '${_movie!.date}';
      }
    } else if (_movie?.genres != null) {
      text = _movie!.genres;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // информация о жанрах и годе производства
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            getDateAndGenre(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w400, color: Colors.white38),
          ),
        ),
        // длительность фильма
        _movie!.duration.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _movie!.duration,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.white38),
                ),
              ),

        //описание фильма
        _movie!.overview!.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: _myHeight * 0.15,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${_movie!.overview}',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, height: 1.4),
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
                ],
              ),
        _movie!.imdbRat.isEmpty
            ? const SizedBox()
            :
            //рейтинг фильма и количество оценок
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Ratings(_movie!.imdbRat, _movie!.imdbVotes),
              ),

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
}
