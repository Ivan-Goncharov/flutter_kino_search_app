import 'package:flutter/material.dart';

import '../../screens/cast_screens/all_actor_screen.dart';
import '../../models/request_querry/credits_info_request.dart';
import '../../widgets/detailed_widget/item_actor_info.dart';

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
          height: height * 0.27,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return ItemActorInfo(actor: actors![index]);
            },
            itemCount: lenghtActorsList > 10 ? 10 : lenghtActorsList,
          ),
        ),
      ],
    );
  }
}
