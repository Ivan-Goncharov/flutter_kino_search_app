import 'package:flutter/material.dart';
import '../../models/credits_info.dart';
import '../../screens/all_crew_screen.dart';
import '../../screens/detailed_cast_item.dart';

//виджет для вывода съемочной группы
class CrewCast extends StatelessWidget {
  //принимаем информацию о съемочной группе
  // и высоту
  final CreditsMovieInfo? creditsInfo;
  final double height;
  const CrewCast({
    Key? key,
    required this.height,
    required this.creditsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // получаем список работников съемочной группы
    final crewList = creditsInfo?.customCrewList;
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
          height: height * 0.18,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final crew = crewList![index];
              return crewInfo(
                context: context,
                crew: crew,
                heroKey: 'crewHero$index',
              );
            },
            itemCount: lenghtCrewList > 10 ? 10 : lenghtCrewList,
          ),
        ),
      ],
    );
  }

// карта одного работнка
  Widget crewInfo(
      {required BuildContext context,
      required Cast crew,
      required String heroKey}) {
    return GestureDetector(
      onTap: () {
        //при нажатии на экран с работником -
        //плавный переход на экран с детальным описанием
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return DetailedCastInfo(
                heroKey: heroKey,
                castItem: crew,
              );
            }),
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        color: const Color.fromARGB(0, 20, 20, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            width: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //фото с закругленными краями
                // оборачиваем в Hero  для анимации
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Hero(
                    tag: heroKey,
                    child: Image(
                      image: crew.getImage(),
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // имя
                      Text(
                        crew.name,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // должность
                      Text(
                        crew.job ?? '',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
