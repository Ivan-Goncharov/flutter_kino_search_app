import 'package:flutter/material.dart';

import '../providers/movie.dart';

//экран для подробного описания фильма и возрастных ограничений
class FullMovieDesciption extends StatefulWidget {
  const FullMovieDesciption({Key? key}) : super(key: key);
  static const routNamed = './fullMovieDescr';

  @override
  _FullMovieDesciptionState createState() => _FullMovieDesciptionState();
}

class _FullMovieDesciptionState extends State<FullMovieDesciption> {
  //принимаем фильм через аргументы Навигатора
  late final Movie _movie;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    //инициализируем данные
    _iniz(context);
    super.didChangeDependencies();
  }

  //получаем фильм и запрашиваем возрастные ограничения по фильму
  _iniz(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    _movie.getCertification().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  //данный метод позволяет подобрать изображение,
  //в зависимости от американского рейтинга
  String getImageLimitUs(String limit) {
    switch (limit) {
      case 'G':
        return 'assets/image/mpa_rated_G.png';
      case 'PG':
        return 'assets/image/mpa_rated_pg.png';
      case 'PG-13':
        return 'assets/image/mpa_rated_pg_13.png';
      case 'R':
        return 'assets/image/mpa_rated_r.png';
      default:
        return 'assets/image/mpa_rated_nc-17.png';
    }
  }

  //данный метод позволяет подобрать изображение,
  //в зависимости от российского рейтинга
  String getImageLimitRu(String limit) {
    switch (limit) {
      case '0':
        return 'assets/image/rars_rated_0.png';
      case '6+':
        return 'assets/image/rars_rated_6.png';
      case '12+':
        return 'assets/image/rars_rated_12.png';
      case '16+':
        return 'assets/image/rars_rated_16.png';
      default:
        return 'assets/image/rars_rated_18.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Описание',
          textAlign: TextAlign.center,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      '${_movie.overview}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, height: 1.4),
                    ),
                  ),
                  Row(
                    children: [
                      _movie.ageLimitRu.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image(
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                                image: AssetImage(
                                  getImageLimitRu(_movie.ageLimitRu),
                                ),
                              ),
                            )
                          : const Text(''),
                      _movie.ageLimitUS.isNotEmpty
                          ? Image(
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              color: Colors.white,
                              image: AssetImage(
                                getImageLimitUs(_movie.ageLimitUS),
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
