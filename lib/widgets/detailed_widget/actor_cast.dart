import 'package:flutter/material.dart';

import '../../screens/all_actor_screen.dart';
import '../../models/credits_info_request.dart';
import '../../screens/detailed_cast_item.dart';

//виджет для вывода актеров
class ActorCast extends StatelessWidget {
  //принимаем информацию об актерском составе
  // и высоту
  final CreditsInfoRequest? creditsInfo;
  final double height;
  const ActorCast({
    Key? key,
    required this.height,
    required this.creditsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // проверяем длину списка актеров
    final actors = creditsInfo?.getCast();
    final lenghtActorsList = actors?.length ?? 0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Актеры',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // в заголовке кнопка - переход на расширенный список,
              // также выводим длину списка - указываем кол-во актеров
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AllActorScreen.routNamed,
                      arguments: actors);
                },
                child: Row(
                  children: [
                    Text(
                      '$lenghtActorsList',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        //контейнер содержит горизонтальный скроллинг
        // выводим постер, имя и героя
        // в списке 10 самых важных ролей,
        // остальных можно посмотреть в расширенном списке
        Container(
          padding: const EdgeInsets.only(top: 8),
          width: double.infinity,
          height: height * 0.25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final actor = actors![index];

              return actorInfo(
                context: context,
                actor: actor,
                heroKey: 'actorHero$index',
              );
            },
            itemCount: lenghtActorsList > 10 ? 10 : lenghtActorsList,
          ),
        ),
      ],
    );
  }

  // Шаблон для вывода одного актера
  Container actorInfo(
      {required BuildContext context,
      required Cast actor,
      required String heroKey}) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // при нажатии на карту с актером -
          //открывается детальное описание
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) {
                return DetailedCastInfo(
                  heroKey: heroKey,
                  castItem: actor,
                );
              }),
              transitionDuration: const Duration(milliseconds: 700),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //постер с закругленными краями
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Hero(
                tag: heroKey,
                child: Image(
                  image: actor.getImage(),
                  height: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // имя и фамилия актера
            Text(
              actor.name,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // если есть, то имя персонажа
            Text(
              '${getActorChapter(actor)}',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  color: Colors.white54, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      padding: const EdgeInsets.only(right: 10),
      width: 105,
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
}
