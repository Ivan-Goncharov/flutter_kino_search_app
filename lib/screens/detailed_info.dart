import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/detailed_widget/actor_cast.dart';

import '../providers/movie.dart';
import '../widgets/error_message_widg.dart';
import '../widgets/detailed_widget/movie_details_column.dart';

//класс с подробным описанием фильма
class DetailedInfo extends StatefulWidget {
  const DetailedInfo({Key? key}) : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  var _isLoading = false;
  Movie? _movie;
  var _isError = false;

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    _iniz();
    super.didChangeDependencies();
  }

  // метод для запуска запросов
  // после завершения запроса о деталях фильма, делаем запрос о рейтинге фильма
  _iniz() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });
      if (_movie != null) {
        await _movie!.detailedMovie().then(
              (_) => {
                _movie!.getRating(),
                _movie!.getTrailer(),
                _movie!.getMovieCredits()
              },
            );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print('Поймана ошибка $error');
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _myHeight = MediaQuery.of(context).size.height;
    final _myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('${_movie!.title}'),
      ),
      body: _isError
          ? ErrorMessageWidget(
              handler: _iniz,
              size: MediaQuery.of(context).size,
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: _myHeight * 0.85,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //размытый постер
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/original${_movie!.imageUrl}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          //постер на переднем плане, подключаем анимацию -
                          //для плавного изменеия размеров и положения виджета
                          Positioned(
                            bottom: 170,
                            child: SizedBox(
                              width: _myWidth * 0.75,
                              height: _myHeight * 0.5,
                              child: Image.network(
                                  'https://image.tmdb.org/t/p/original${_movie!.imageUrl}'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // расширяющийся список
                    DraggableScrollableSheet(
                      initialChildSize: 0.25,
                      maxChildSize: 1,
                      minChildSize: 0.20,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Opacity(
                          opacity: 0.96,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              color: Colors.black,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MovieDetailsColumn(
                                      movie: _movie, myHeight: _myHeight),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
