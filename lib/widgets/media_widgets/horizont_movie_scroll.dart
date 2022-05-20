import 'package:flutter/material.dart';

import '../../models/firebase_models/movies_history.dart';
import '../../providers/movie.dart';
import 'search_item.dart';
import '../../screens/all_search_results.dart';

// виджет для горизонтального скроллинuга фильмов и сералов
class HorrizontalMovieScroll extends StatelessWidget {
  final String title;
  final List<MediaBasicInfo> list;
  final Size size;
  final bool isMovie;
  final MovieHistory historySearch;
  final bool isSearch;
  final String text;
  final String typeScroll;

  const HorrizontalMovieScroll({
    Key? key,
    required this.title,
    required this.list,
    required this.size,
    required this.isMovie,
    required this.isSearch,
    required this.historySearch,
    required this.text,
    required this.typeScroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //выводим необходимый заголовок, сопровождающий скроллинг
        Text(
          title,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          height: size.height * 0.29,
          child: ListView.builder(
            //так как это внутренний скролл, то указываем эти свойства
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            // скрываем клавиатуру при скроллинге
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: list.length,
            itemBuilder: (context, index) {
              //если конец списка в поиске, то выводим кнопку,
              //которая предлагает перейти на экран со всеми результатами
              if (index == list.length - 1 && list.length > 11 && isSearch) {
                return EndListButton(isMovie: isMovie, text: text);
              }
              // один элемент скроллинга - это постер фильма
              //с возмоностью перехода на экран с детальной ин-фой
              return SearchItem(
                movie: list[index],
                movieHistory: historySearch,
                typeScroll: typeScroll,
                isSearch: isSearch,
              );
            },
          ),
        ),
      ],
    );
  }
}

//кнопка перехода на экран со всеми результатми
class EndListButton extends StatelessWidget {
  //флаг - что мы ищем
  //true - фильмы
  //false - сериалы
  final bool isMovie;

  //заголовок, который мы ищем
  final String text;
  const EndListButton({Key? key, required this.isMovie, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.35,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AllSearchResult.routNamed,
            arguments: {
              'searchText': text,
              'isMovie': isMovie,
            },
          );
        },
        child: Text(
          'Все результаты',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
