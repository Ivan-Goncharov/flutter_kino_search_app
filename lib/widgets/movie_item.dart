import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';
import '../screens/detailed_movie_info.dart';

//виджет для вывода карточки с одним фильмом в поиске фильмов
class MovieItem extends StatelessWidget {
  //принимаем информацию о фильме в аргументе и выводим ее на экран
  final Movie movie;
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

// проверяем на переданное изображение - постер,
// если ссылка на изображение noImageFound,
// то возвращаем соотвествующий файл
  Image getImage(String? imageUrl) {
    if (imageUrl!.contains('noImageFound')) {
      return Image.asset(imageUrl);
    } else {
      return Image.network('https://image.tmdb.org/t/p/w300$imageUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = 'movieItem${movie.id}';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 100,
          child: FittedBox(
            fit: BoxFit.contain,
            //выводим постер на экран

            child: Hero(
              child: getImage(movie.imageUrl),
              tag: heroTag,
            ),
          ),
        ),

        title: Text(
          '${movie.title}',
        ),
        subtitle: Text('${movie.originalTitle}, ${movie.date}'),

        //по нажатию переходим на экран с подробным описанием фильма
        onTap: () {
          Provider.of<Movies>(context, listen: false).addMovieHistory(movie);
          // Navigator.pushNamed(
          //   context,
          //   DetailedInfo.routName,
          //   arguments: movie,
          // );
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) {
                return DetailedInfo(
                    movie: movie,
                    heroTag: heroTag,
                    image: getImage(movie.imageUrl));
              }),
              transitionDuration: const Duration(milliseconds: 700),
              reverseTransitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
      ),
    );
  }
}
