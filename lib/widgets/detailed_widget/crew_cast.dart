import 'package:flutter/material.dart';
import '../../models/request_querry/credits_info_request.dart';
import '../../screens/cast_screens/all_crew_screen.dart';
import '../../screens/cast_screens/detailed_cast_item.dart';

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
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

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
          height: size.height * 0.21,
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
                size: size,
                colors: colorScheme,
              );
            },
            itemCount: lenghtCrewList > 10 ? 10 : lenghtCrewList,
          ),
        ),
      ],
    );
  }

// карта одного работнка
  Widget crewInfo({
    required BuildContext context,
    required Cast crew,
    required String heroKey,
    required Size size,
    required ColorScheme colors,
  }) {
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
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        elevation: 10,
        child: ClipRRect(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            width: size.width * 0.65,
            decoration: BoxDecoration(
              // border: Border.all(color: colors.onSurface),
              borderRadius: BorderRadius.circular(8.0),
            ),
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
                      height: size.height * 0.13,
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
                        '${getCrewJobs(crew)}',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 14,
                            color: colors.onInverseSurface,
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
