import 'package:flutter/material.dart';

import '../models/credits_info.dart';

class AllCastPerson extends StatefulWidget {
  static const routNamed = './allActorsRout';
  const AllCastPerson({Key? key}) : super(key: key);

  @override
  State<AllCastPerson> createState() => _AllCastPersonState();
}

class _AllCastPersonState extends State<AllCastPerson> {
  List<Cast>? _castsList;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    _castsList = ModalRoute.of(context)!.settings.arguments as List<Cast>?;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Актеры'),
      ),
      body: _isLoading
          ? getProgressBar()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return getActorCard(_castsList![index]);
                },
                itemCount: _castsList?.length ?? 0,
              ),
            ),
    );
  }

  Widget getActorCard(Cast castPers) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              //Постер с фотографией работника
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: castPers.getImage(),
                  height: 80,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //имя актера
                  Text(
                    castPers.name,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //Оригинальное имя актера
                  Text(
                    castPers.originalName,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //имя персонажа
                  Text(
                    castPers.character ?? '',
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              )
            ],
          ),
        ),
        const Divider(height: 3.0),
      ],
    );
  }

  Center getProgressBar() {
    return Center(
      child: Column(
        children: const [
          CircularProgressIndicator(),
          Text('Загружаем список'),
        ],
      ),
    );
  }
}
