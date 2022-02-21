import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:provider/provider.dart';

import '../providers/movie.dart';
import '../screens/detailed_info.dart';

//виджет для вывода карточки с одним фильмом в поиске фильмов
class MovieItem extends StatelessWidget {
  //принимаем информацию о фильме в аргументе и выводим ее на экран
  final Movie movie;
  const MovieItem({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 100,
          child: FittedBox(
            fit: BoxFit.contain,
            //выводим постер на экран
            //если ссылка на изображение не рабочая, выводим дефолтное
            child: movie.imageUrl!.contains('noImageFound')
                ? Image.asset('${movie.imageUrl}')
                : Image.network(
                    'https://image.tmdb.org/t/p/w185${movie.imageUrl}'),
          ),
        ),
        title: Text(
          '${movie.title}',
        ),
        subtitle: Text('${movie.originalTitle}, ${movie.date}'),

        //по нажатию переходим на экран с подробным описанием фильма
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailedInfo.routName,
            arguments: movie,
          );
        },
      ),
    );
  }
}
