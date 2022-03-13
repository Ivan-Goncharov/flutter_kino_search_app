import 'package:flutter/material.dart';
import '../../models/credits_info_request.dart';
import '../../screens/cast_screens/detailed_cast_item.dart';

//виджет для вывода одного работника фильма
//в расширенном списке фильмов
class SinglePersonItem extends StatelessWidget {
  final Cast castPers;
  final bool isActor;
  final String heroKey;
  const SinglePersonItem({
    Key? key,
    required this.castPers,
    required this.isActor,
    required this.heroKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        // обрабатываем нажатие на карту -
        // переходом на страницу с описанием работника
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return DetailedCastInfo(
                heroKey: heroKey,
                castItem: castPers,
              );
            }),
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      },
      child: Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  //Постер с фотографией работника
                  //оборачиваем в виджет Hero, и присваиваем полученный tag от вызвавшего виджета
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Hero(
                      tag: heroKey,
                      child: Image(
                        image: castPers.getImage(),
                        height: size.height * 0.15,
                        width: size.width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //имя актера
                        Text(
                          castPers.name,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        //имя персонажа или должность
                        //если актер - то выводим имя персонажа,
                        // если не актер, то должность
                        isActor
                            ? Text(
                                '${getActorChapter(castPers)}',
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: colorScheme.onInverseSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.start,
                              )
                            : Text(
                                '${getCrewJobs(castPers)}',
                                softWrap: true,
                                style: TextStyle(
                                  color: colorScheme.onInverseSurface,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.start,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // возвращаем имя персонажа,
  // для сериалов и для фильмов различная запись ролей,
  // поэтому проверяем как записано и возвращаем имя героя, исходя из записи
  String? getActorChapter(Cast actor) {
    if (actor.roles != null) {
      if (actor.roles?[0].character != null) {
        return actor.roles![0].character;
      } else {
        return '';
      }
    } else if (actor.character != null) {
      return actor.character;
    } else {
      return '';
    }
  }

  // возвращаем название должности у персонала съемочной группы
  String? getCrewJobs(Cast crew) {
    // если персонал сериалов, то получаем должность так
    if (crew.jobs != null) {
      if (crew.jobs?[0].job != null) {
        return crew.jobs![0].job;
      } else {
        return '';
      }
      // если персонал фильма, то так
    } else if (crew.job != null) {
      return crew.job;
    } else {
      return '';
    }
  }
}
