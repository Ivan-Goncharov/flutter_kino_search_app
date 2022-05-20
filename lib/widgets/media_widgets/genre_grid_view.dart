import 'package:flutter/material.dart';

import '../detailed_widget/get_image.dart';
import '../../providers/movie.dart';
import '../../screens/movie_detailes_info/detailed_movie_info.dart';

//виджет, который создает GridView c фильмами конкретного жанра
class ItemGenreGridView extends StatelessWidget {
  //список фильмов
  final List<MediaBasicInfo> listOfMedia;
  const ItemGenreGridView({Key? key, required this.listOfMedia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      //заполняем экран сеткой в 3 элемента
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          //тэг hero для анимации
          final heroTag = 'genreGridView$index${listOfMedia[index].id}';
          return GestureDetector(
            onTap: () {
              //обрабатываем нажатие на постер
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    // вызываем деатльную информацию о фильме
                    // передаем фильм и тэг hero
                    return DetailedInfoScreen(
                      movie: listOfMedia[index],
                      heroTag: heroTag,
                    );
                  }),
                  transitionDuration: const Duration(milliseconds: 700),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            // выводим постер фильма через анимацию
            child: Hero(
              tag: heroTag,
              child: GetImage(
                  imageUrl: listOfMedia[index].imageUrl,
                  title: listOfMedia[index].title,
                  height: 300,
                  width: 150),
            ),
          );
        },
        itemCount: listOfMedia.length,
      ),
    );
  }
}
