import 'package:flutter/material.dart';

import '../../screens/movie_detailes_info/detailed_movie_info.dart';
import '../../providers/movie.dart';
import '../detailed_widget/get_image.dart';

//список фильмов или сериалов, которые пользователь отметил как любимый
class FavoriteMoviesList extends StatelessWidget {
  //cписок медиао
  final List<MediaBasicInfo> listOfMedia;
  //функция для изменения списка, в случае изменения статуса фильма
  final Function changeList;

  const FavoriteMoviesList(
      {Key? key, required this.listOfMedia, required this.changeList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      //заполняем экран сеткой в 3 элемента
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          //тэг hero для анимации
          final heroTag = 'gridView$index${listOfMedia[index].id}';
          return GestureDetector(
            onTap: () async {
              // ожидаем результат следующего экрана,
              // если в детальном экране медиа изменили статус фильма, то перестраиваем виджет
              final result = await Navigator.push(
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

              //перестраиваем виджет с новыми данными
              if (result) {
                changeList();
              }
            },
            // выводим ипостер фильма
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
