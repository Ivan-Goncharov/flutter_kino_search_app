import 'package:flutter/material.dart';

import '../../widgets/detailed_widget/single_person_item.dart';
import '../../models/request_querry/credits_info_request.dart';

//Экран со списком всех актеров фильма
class AllActorScreen extends StatefulWidget {
  static const routNamed = './allActorsRout';
  const AllActorScreen({Key? key}) : super(key: key);

  @override
  State<AllActorScreen> createState() => _AllActorScreenState();
}

class _AllActorScreenState extends State<AllActorScreen> {
  //список актеров
  List<Cast>? _castsList;
  var _isLoading = false;

  //инициализируем список через аргументы навигатора
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
          ? Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  Text('Загружаем список'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              // выводим все карточки актеров
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return SinglePersonItem(
                    castPers: _castsList![index],
                    isActor: true,
                    heroKey: 'allActorHero$index',
                  );
                },
                itemCount: _castsList?.length ?? 0,
              ),
            ),
    );
  }
}
