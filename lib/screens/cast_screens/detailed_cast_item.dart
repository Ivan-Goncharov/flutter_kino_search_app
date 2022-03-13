import 'package:flutter/material.dart';

import '../../providers/cast.dart';
import '../../widgets/detailed_widget/get_image.dart';
import '../../models/credits_info_request.dart';
import '../../providers/movie.dart';
import '../movie_detailes_info/detailed_movie_info.dart';

//экран с детальным описанием актера
class DetailedCastInfo extends StatefulWidget {
  //принимаем информацию об актере и herokey для анимации
  final String heroKey;
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
  bool _isLoading = false;
  List<MediaBasicInfo> _moviesActor = [];
  List<MediaBasicInfo> _moviesCrew = [];
  late DraggableScrollableController _scrContr;
  var _hideBackBut = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _scrContr = DraggableScrollableController();
    _scrContr.addListener(_listener);
    _castInfo = ItemCastInfo(widget.castItem.id);
    _castInfo!.getCastInfo();
    _castInfo!.getMovieInfo().then((_) {
      _moviesActor = _castInfo?.mapMovies['Актер'] ?? [];
      _moviesCrew = _castInfo?.mapMovies['Съемочная группа'] ?? [];
      _moviesActor.sort(
        (a, b) => b.voteCount!.compareTo(a.voteCount as int),
      );
      _moviesCrew.sort(
        (a, b) => b.voteCount!.compareTo(a.voteCount as int),
      );

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
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
                        height: MediaQuery.of(context).size.height * 0.89,
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
              DraggableScrollableSheet(
                // controller: _scrContr,
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
                            Text(
                              widget.castItem.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            _isLoading
                                ? Container(
                                    alignment: Alignment.topCenter,
                                    padding: const EdgeInsets.only(top: 20),
                                    child: const CircularProgressIndicator(
                                        color: Colors.white38),
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          _castInfo!.birthday +
                                              _castInfo!.deathday,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '${_castInfo?.age}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      _moviesActor.isNotEmpty
                                          ? createDeportament(context,
                                              _moviesActor, 'Актер', size)
                                          : const SizedBox(),
                                      _moviesCrew.isNotEmpty
                                          ? createDeportament(
                                              context,
                                              _moviesCrew,
                                              'Съемочная группа',
                                              size)
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

  Column createDeportament(BuildContext context, List<MediaBasicInfo> list,
      String depName, Size size) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(8.0),
          child: Text(depName,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium),
        ),
        createGridView(context, list, size),
      ],
    );
  }

  Widget createGridView(
      BuildContext ctx, List<MediaBasicInfo> movie, Size size) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 3,
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (ctx, index) {
          final heroTag = 'gridView$index${movie[index].id}';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) {
                    return DetailedInfoScreen(
                      movie: movie[index],
                      heroTag: heroTag,
                    );
                  }),
                  transitionDuration: const Duration(milliseconds: 700),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: GetImage(
                  imageUrl: movie[index].imageUrl,
                  title: movie[index].title,
                  height: size.height * 0.1,
                  width: size.width * 0.2),
            ),
          );
        },
        itemCount: movie.length,
      ),
    );
  }
}
