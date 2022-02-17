import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/movies.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/movie_info.dart';

//класс с подробным описанием фильма
class DetailedInfo extends StatefulWidget {
  const DetailedInfo({Key? key}) : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  // переменные для работы с размерами изображения в стэке
  late double _myHeight;
  late double _myWidth;
  late double _imageHeight;
  late double _imageWidth;
  //начальная позиция изображения
  double _bottomSize = 170.0;
  //контроллер для отслеживания положения прокручеваемой части
  late DraggableScrollableController _scrollController;
  //принимаем через аргументы навигации фильм
  late final int _movieId;
  var _isLoading = false;
  late MovieInfo _movie;

  @override
  void initState() {
    //инициализируем контроллер
    _scrollController = DraggableScrollableController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future _detailedMovie(int movieId) async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=2115a4e4d0db6b9e7298306e0f3a6817&language=ru');
    final response = await http.get(url).then((_) {});
    setState(() {
      _isLoading = false;
    });
    _movie = MovieInfo.fromJson(json.decode(response.body));
  }

  //получаем размеры экрана и задаем начальные размеры для постера фильма
  @override
  void didChangeDependencies() {
    _myHeight = MediaQuery.of(context).size.height;
    _myWidth = MediaQuery.of(context).size.width;
    _imageHeight = _myHeight * 0.5;
    _imageWidth = _myWidth * 0.75;
    _movieId = ModalRoute.of(context)!.settings.arguments as int;
    // _inizialisingMovie(_movieId, context);
    super.didChangeDependencies();
  }

  // // получаем более пордробное описание фильма
  // Future<void> _inizialisingMovie(int id, BuildContext context) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await Provider.of<Movies>(context, listen: false).detailedMovie(id).then(
  //     (_) {
  //       _movie = Provider.of<Movies>(context, listen: false).movieItem;
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     },
  //   );
  // }

  ///слушатель для контроллера
  ///чем больше пространства занимает ScrollSheet, тем меньше изображение
  /// и выше его позиция в стеке
  _scrollListener() {
    if (_scrollController.size < 0.15) {
      _changeSize(iHeight: 0.6, iWidth: 0.85);
      _bottomSize = 90;
    } else if (_scrollController.size < 0.2) {
      _changeSize(iHeight: 0.55, iWidth: 0.80);
      _bottomSize = 120;
    } else if (_scrollController.size < 0.25) {
      _changeSize(iHeight: 0.5, iWidth: 0.75);
      _bottomSize = 170;
    } else if (_scrollController.size < 0.3) {
      _changeSize(iHeight: 0.45, iWidth: 0.70);
      _bottomSize = 220;
    } else if (_scrollController.size < 0.4) {
      _changeSize(iHeight: 0.4, iWidth: 0.65);
      _bottomSize = 270;
    } else {
      _changeSize(iHeight: 0.35, iWidth: 0.6);
      _bottomSize = 320;
    }
  }

  /// метод для изменения размеров ихображения
  /// получаем дробную величину, которая означает процентное отношение
  /// размера изображения к размеру экрана и меняем размер изображения
  _changeSize({
    required double iHeight,
    required double iWidth,
  }) {
    setState(() {
      _imageHeight = _myHeight * iHeight;
      _imageWidth = _myWidth * iWidth;
    });
  }

  // //метод для конвертации даты в String
  // String getDate(DateTime date) {
  //   return DateFormat('yyyy-MM-dd').format(date).substring(0, 4);
  // }

  @override
  Widget build(BuildContext context) {
    _detailedMovie(_movieId);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? '...' : '${_movie.title}'),
      ),
      // используем стэк, для того, чтобы фоном было размытый постер
      // а на переднем плане постер без размытия
      body: _isLoading
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
                                  'https://image.tmdb.org/t/p/original${_movie.posterPath}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      //постер на переднем плане, подключаем анимацию -
                      //для плавного изменеия размеров и положения виджета
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 120),
                        bottom: _bottomSize,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: _imageWidth,
                          height: _imageHeight,
                          child: Image.network(
                              'https://image.tmdb.org/t/p/original${_movie.posterPath}'),
                        ),
                      ),
                    ],
                  ),
                ),

                // расширяющийся список
                DraggableScrollableSheet(
                  controller: _scrollController,
                  initialChildSize: 0.25,
                  maxChildSize: 1,
                  minChildSize: 0.05,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.black,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                //Название фильма на русском
                                Text(
                                  '${_movie.title}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                //название фильма на языке оригинала
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '${_movie.originalTitle}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                // информация о жанре, производителе,  годе и
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    // ignore: unnecessary_string_interpolations
                                    _movie.getDate() +
                                        ', ' +
                                        _movie.getGenres(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white38),
                                  ),
                                ),
                              ],
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
