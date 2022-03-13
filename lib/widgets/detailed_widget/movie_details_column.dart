import 'package:flutter/material.dart';

import '../../models/details_media_mod.dart';
import '../../screens/movie_detailes_info/wath_providers_screen.dart';
import '../../providers/movie.dart';
import '../../screens/movie_detailes_info/full_movie_descrip.dart';
import 'ratings.dart';
import 'actor_cast.dart';
import 'crew_cast.dart';

//Виджет для отображения подробной информации о фильме
class MovieDetailsColumn extends StatelessWidget {
  const MovieDetailsColumn({
    Key? key,
    required DetailsMediaMod? details,
    required double myHeight,
    required MediaBasicInfo? media,
  })  : _details = details,
        _myHeight = myHeight,
        _media = media,
        super(key: key);

  final DetailsMediaMod? _details;
  final double _myHeight;
  final MediaBasicInfo? _media;

  String getDateAndGenre() {
    String date = _details?.date ?? '';
    if (_details!.lastEpisodeDate != '') {
      date += ' - ${_details!.lastEpisodeDate}';
    }
    String text = '';
    if (date != '') {
      if (date != '') {
        text = '$date г.  ${_details!.genres}';
      } else {
        text = '$date г.';
      }
    } else if (_details?.genres != null) {
      text = _details!.genres;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // информация о жанрах и годе производства
        getDateAndGenre() != ''
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  getDateAndGenre(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onInverseSurface),
                ),
              )
            : const SizedBox(),
        // длительность фильма
        _details!.duration.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${_details!.duration}${_details!.numberOfSeasons()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onInverseSurface),
                ),
              ),

        //описание фильма
        _details!.overview.isEmpty
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 8.0, left: 8.0, bottom: 2.0),
                    child: Text(
                      _details!.overview,
                      textAlign: TextAlign.start,
                      maxLines: 6,
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
                        arguments: _details,
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
        _details!.imdbRat.isEmpty
            ? const SizedBox()
            :
            //рейтинг фильма и количество оценок
            Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Ratings(_details!.imdbRat, _details!.imdbVotes),
              ),

        // проверяем есть ли данные о прокатчике в России
        _details?.watchProviders?.results.ru == null
            ? const SizedBox()
            :
            // кнопка переход на страницу с ссылками на сервисы для просмотра онлайн
            GestureDetector(
                onTap: (() {
                  Navigator.pushNamed(context, WatchProvidersScreen.routNamed,
                      arguments: {
                        'details': _details,
                        'media': _media,
                      });
                }),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  height: _myHeight * 0.07,
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.live_tv_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Смотреть онлайн',
                          style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

        _details?.creditsInfo?.cast.isEmpty ?? false
            ? const SizedBox()
            :
            //горизонтальный скроллинг список актеров
            ActorCast(
                height: _myHeight,
                creditsInfo: _details!.creditsInfo,
              ),

        _details?.creditsInfo?.crew.isEmpty ?? false
            ? const SizedBox()
            :
            //горизонтальный скроллинг список съемочной группы
            CrewCast(
                creditsInfo: _details!.creditsInfo,
              ),
      ],
    );
  }
}
