import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/models/credits_info.dart';
import 'package:flutter_my_kino_app/screens/all_cast_person.dart';

//виджет для вывода актеров
class ActorCast extends StatelessWidget {
  //принимаем информацию об актерском составе
  // и высоту
  final CreditsMovieInfo? creditsInfo;
  final double height;
  ActorCast({
    Key? key,
    required this.height,
    required this.creditsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // проверяем длину списка актеров
    final actors = creditsInfo?.cast;
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // в заголовке кнопка - переход на расширенный список,
              // также выводим длину списка - указываем кол-во актеров
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AllCastPerson.routNamed,
                      arguments: actors);
                },
                child: Row(
                  children: [
                    Text(
                      '$lenghtActorsList',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white54,
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
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: height * 0.30,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final actor = actors![index];

              return actorInfo(actor);
            },
            itemCount: lenghtActorsList > 10 ? 10 : lenghtActorsList,
          ),
        ),
      ],
    );
  }

  // Шаблон для вывода одного актера
  Container actorInfo(Cast actor) {
    return Container(
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              image: actor.getImage(),
              height: 100,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            actor.character ?? '',
            softWrap: true,
            style: const TextStyle(
              color: Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      width: 120,
    );
  }
}
