import 'package:flutter/material.dart';

import '../../models/media_models/cast.dart';
import '../../models/request_querry/credits_info_request.dart';
import '../../providers/movie.dart';
import '../../widgets/detailed_widget/grid_view_depart.dart';
import '../../widgets/system_widgets/error_message_widg.dart';

//экран с детальным описанием актера
class DetailedCastInfo extends StatefulWidget {
  //принимаем информацию об актере и herokey для анимации
  final Key heroKey;
  final Cast castItem;
  const DetailedCastInfo({
    required this.heroKey,
    required this.castItem,
    Key? key,
  }) : super(key: key);

  @override
  _DetailedCastInfoState createState() => _DetailedCastInfoState();
}

class _DetailedCastInfoState extends State<DetailedCastInfo> {
  //Создаем объект класса с детальным описанием работника
  ItemCastInfo? _castInfo;
  //переменная для загрузки
  bool _isLoading = false;
  //отслеживаение ошибки
  bool _isError = false;
  //список актеров и список работников
  List<MediaBasicInfo> _moviesActor = [];
  List<MediaBasicInfo> _moviesCrew = [];
  //скролл контроллер
  late DraggableScrollableController _scrContr;
  //флаг для скрытия кнопки "назад"
  var _hideBackBut = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    //инициализируем контроллер для прокрутки экрана
    _scrContr = DraggableScrollableController();
    _scrContr.addListener(_listener);

    _iniz();
    super.initState();
  }

  //метод для инициализации данных об актере
  _iniz() async {
    setState(() => _isError = false);

    //получаем информацию об одном артисте
    _castInfo = ItemCastInfo(widget.castItem.id);

    //делаем запрос на поиск всех фильмов, в которых принимал участие артист
    // и на детальную информацию о нем
    await Future.wait([
      _castInfo!.getCastInfo(),
      _castInfo!.getMovieInfo(),
    ]).then((value) {
      //если уже вышли с экрана, то выходим из метода
      if (!mounted)
        return;

      //если ошибка в одном из методов, то вызываем экран с ошибкой
      else if (!value[0] || !value[1])
        setState(() => _isError = true);

      //если все хорошо, то выводим данные
      else {
        _moviesActor = _castInfo?.mapOfMedia['Актер'] ?? [];
        _moviesCrew = _castInfo?.mapOfMedia['Съемочная группа'] ?? [];

        // сортируем фильмы, где артист участвует как актер
        _moviesActor.sort(
          (a, b) => b.voteCount!.compareTo(a.voteCount as int),
        );

        //сортируем фильмы, где артист участвует как участник съемочной группы
        _moviesCrew.sort(
          (a, b) => b.voteCount!.compareTo(a.voteCount as int),
        );

        setState(() => _isLoading = false);
      }
    });
  }

  //слушатель для положения прокручивающегося списка, чтобы убирать или показывать кнопку "Назда"
  _listener() {
    if (_scrContr.size < 0.93 && _hideBackBut) {
      setState(() {
        _hideBackBut = false;
      });
    }
    if (_scrContr.size > 0.90 && !_hideBackBut) {
      setState(() {
        _hideBackBut = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _isError

            //если ошибка, то вызываем экран с ошибкой
            ? ErrorMessageWidget(handler: _iniz, size: size)

            //иначе показываем подробные данные
            : Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),

                //постер с фото актера
                child: Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: widget.heroKey,
                            child: Image(
                              image: widget.castItem.getImage(),
                              height: MediaQuery.of(context).size.height * 0.9,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _hideBackBut
                        ? const SizedBox()
                        :
                        //кнопка "назад"
                        Positioned(
                            top: 10,
                            left: 8,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                size: 35,
                              ),
                            ),
                          ),

                    //прокручивающаяся часть экрана
                    DraggableScrollableSheet(
                      initialChildSize: 0.16,
                      minChildSize: 0.16,
                      maxChildSize: 0.93,
                      builder: (context, scrollController) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
                            padding: const EdgeInsets.only(top: 27),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  //имя артиста
                                  Text(
                                    widget.castItem.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),

                                  // подробные данные
                                  _isLoading
                                      ? Container(
                                          alignment: Alignment.topCenter,
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onInverseSurface),
                                        )
                                      : Column(
                                          children: [
                                            //данные о датах рождения и смерти(если есть)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                _castInfo!.birthday +
                                                    _castInfo!.deathday,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),

                                            //данные о возрасте
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                '${_castInfo?.age}',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),

                                            //сетка с фильмами, как Актер
                                            _moviesActor.isNotEmpty
                                                ? CastDepartament(
                                                    depName: 'Актер',
                                                    list: _moviesActor,
                                                  )
                                                : const SizedBox(),

                                            //сетка с фильмами, как участник съемочной команды
                                            _moviesCrew.isNotEmpty
                                                ? CastDepartament(
                                                    depName: 'Съемочная группа',
                                                    list: _moviesCrew,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
