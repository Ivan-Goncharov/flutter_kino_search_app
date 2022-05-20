import 'package:flutter/material.dart';

import '../../models/request_querry/credits_info_request.dart';
import '../../screens/cast_screens/detailed_cast_item.dart';

//виджет для вывода одного актера в списке актеров
class ItemActorInfo extends StatelessWidget {
  final Cast actor;
  // final String heroKey;
  const ItemActorInfo({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final Key _key = UniqueKey();
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
                  heroKey: _key,
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
                tag: _key,
                child: Image(
                  image: actor.getImage(),
                  height: _size.height * 0.15,
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
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: true,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: _size.height * 0.005,
            ),
            // если есть, то имя персонажа
            Text(
              '${getActorChapter(actor)}',
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      padding: const EdgeInsets.only(right: 10),
      width: _size.width * 0.33,
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
