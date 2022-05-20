import 'package:flutter/material.dart';

import '../../providers/movie.dart';
import '../../screens/movie_detailes_info/detailed_movie_info.dart';
import 'get_image.dart';

//  сетка одного подразделения, либо актер, либо съемочная группа
class CastDepartament extends StatelessWidget {
  //список медиа
  final List<MediaBasicInfo> list;
  //название подразделения

  final String depName;
  const CastDepartament({Key? key, required this.depName, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //название департамента
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(depName,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium),
        ),

        //создаем сетку с фильмами
        ItemGridView(list: list),
      ],
    );
  }
}

class ItemGridView extends StatelessWidget {
//список медиа
  final List<MediaBasicInfo> list;
  const ItemGridView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,

      //сетка с прокруткой внутри
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          //тег для анимации перехода
          final heroTag = 'gridView$index${list[index].id}';
          return GestureDetector(
            //обрабатываем нажатие на постер, открывая детальное описание фильма
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    return DetailedInfoScreen(
                      movie: list[index],
                      heroTag: heroTag,
                    );
                  }),
                  transitionDuration: const Duration(milliseconds: 700),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },

            //выводим постер одного фильма или серила
            child: Hero(
              tag: heroTag,
              child: GetImage(
                  imageUrl: list[index].imageUrl,
                  title: list[index].title,
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2),
            ),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}
