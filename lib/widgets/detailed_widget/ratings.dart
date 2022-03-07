import 'package:flutter/material.dart';

//виджет для вывод рейтинга imdb и количества оценок
class Ratings extends StatelessWidget {
  //принимаем рейтинг и оценки
  final String imdbRat;
  final String imdbVotes;
  const Ratings(this.imdbRat, this.imdbVotes);

  //динамический стиль для текста, меняем цвет, взависимости от оценки
  TextStyle ratTextStyle(String rat) {
    return TextStyle(
        fontSize: 50, color: getColor(rat), fontWeight: FontWeight.bold);
  }

  Color getColor(String rat) {
    if (rat.isNotEmpty && !rat.contains('N/A')) {
      final double movieRat = double.parse(rat);
      if (movieRat >= 7.0) {
        return Colors.green;
      } else if (movieRat >= 5.5) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //заголовок
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Рейтинг IMDB',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //цвет контейнера чуть светлее, чем фон
        Container(
          width: double.infinity,
          // color: const Color.fromRGBO(20, 20, 20, 1),

          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            children: [
              // оценка фильма
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  imdbRat,
                  style: ratTextStyle(imdbRat),
                ),
              ),
              // количество оценок
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 18.0),
                child: Text(
                  imdbVotes,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
