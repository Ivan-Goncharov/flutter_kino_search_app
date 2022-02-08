import 'package:flutter/material.dart';

import '../providers/movie.dart';

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
            child: movie.imageUrl == null
                ? Image.asset('${movie.imageUrl}')
                : Image.network('${movie.imageUrl}'),
          ),
        ),
        title: Text(
          '${movie.title}',
        ),
        subtitle: Text('${movie.originalTitle}, ${movie.date}'),
      ),
    );
  }
}
