import 'package:flutter/material.dart';
import '../../models/media_models/details_media_mod.dart';

//экран для подробного описания фильма и возрастных ограничений
class FullMovieDesciption extends StatefulWidget {
  const FullMovieDesciption({Key? key}) : super(key: key);
  static const routNamed = './fullMovieDescr';

  @override
  _FullMovieDesciptionState createState() => _FullMovieDesciptionState();
}

class _FullMovieDesciptionState extends State<FullMovieDesciption> {
  //принимаем фильм через аргументы Навигатора
  late final DetailsMediaMod _details;
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
    _details = ModalRoute.of(context)!.settings.arguments as DetailsMediaMod;
    setState(() {
      _isLoading = false;
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
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        size: 35,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12, right: 16, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //описание фильма
                          Text('Полное описание',
                              style: Theme.of(context).textTheme.displayMedium),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                            child: Text(
                              _details.overview,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4),
                            ),
                          ),

                          // возрастные лимиты
                          Row(
                            children: [
                              // возрастной рейтинг RASR, если отсуствует, то пустой текст
                              _details.ageLimitRu.isNotEmpty
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image(
                                        width: size.width * 0.15,
                                        height: size.height * 0.15,
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                          getImageLimitRu(_details.ageLimitRu),
                                        ),
                                      ),
                                    )
                                  : const Text(''),

                              //возрастной рейтинг US
                              _details.ageLimitUS.isNotEmpty
                                  ? Image(
                                      width: size.width * 0.22,
                                      height: size.height * 0.22,
                                      fit: BoxFit.contain,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      image: AssetImage(
                                        getImageLimitUs(_details.ageLimitUS),
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
