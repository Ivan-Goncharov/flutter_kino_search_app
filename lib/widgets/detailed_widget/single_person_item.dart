import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/models/credits_info.dart';
import 'package:flutter_my_kino_app/screens/detailed_cast_item.dart';

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
                        height: 80,
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
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
                        height: 5,
                      ),
                      //Оригинальное имя актера
                      Text(
                        castPers.originalName,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //имя персонажа или должность
                      //если актер - то выводим имя персонажа,
                      // если не актер, то должность
                      isActor
                          ? Text(
                              castPers.character ?? '',
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w200,
                              ),
                              textAlign: TextAlign.start,
                            )
                          : Text(
                              castPers.job ?? '',
                              softWrap: true,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w200,
                              ),
                              textAlign: TextAlign.start,
                            ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
