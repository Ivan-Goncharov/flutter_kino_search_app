import 'package:flutter/material.dart';

import '../../models/request_querry/credits_info_request.dart';
import '../../screens/cast_screens/detailed_cast_item.dart';

//виджет для вывода одного работника в списке быстрого досутпа
//к основным рабоникам съемочной площадки фильма
//выводится при общем обзоре фильма
class ItemCrewInfo extends StatelessWidget {
  final Cast crew;
  const ItemCrewInfo({Key? key, required this.crew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Key _key = UniqueKey();
    return GestureDetector(
      onTap: () {
        //при нажатии на экран с работником -
        //плавный переход на экран с детальным описанием
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return DetailedCastInfo(
                heroKey: _key,
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
            width: MediaQuery.of(context).size.width * 0.65,
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
                    tag: _key,
                    child: Image(
                      image: crew.getImage(),
                      height: MediaQuery.of(context).size.height * 0.13,
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
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
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
