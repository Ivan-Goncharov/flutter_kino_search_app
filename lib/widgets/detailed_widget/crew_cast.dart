import 'package:flutter/material.dart';

import '../../models/request_querry/credits_info_request.dart';
import '../../screens/cast_screens/all_crew_screen.dart';
import '../../widgets/detailed_widget/item_crew_info.dart';

//виджет для вывода съемочной группы
class CrewCast extends StatelessWidget {
  //принимаем информацию о съемочной группе
  // и высоту
  final CreditsInfoRequest? creditsInfo;
  const CrewCast({
    Key? key,
    required this.creditsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // получаем список работников съемочной группы
    final crewList = creditsInfo?.getcustomCrewList();
    final lenghtCrewList = crewList?.length ?? 0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Съемочная группа',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // в заголовке кнопка - переход на расширенный список,
              // также выводим длину списка - указываем кол-во работников
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AllCrewScreen.routNamed,
                      arguments: creditsInfo?.custumCrewMap);
                },
                child: Row(
                  children: [
                    Text(
                      '$lenghtCrewList',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        // контейнер содержит горизонтальный скроллинг
        // выводим фото, имя и должность
        Container(
          padding: const EdgeInsets.only(top: 6.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.21,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return ItemCrewInfo(crew: crewList![index]);
            },
            itemCount: lenghtCrewList > 10 ? 10 : lenghtCrewList,
          ),
        ),
      ],
    );
  }
}
