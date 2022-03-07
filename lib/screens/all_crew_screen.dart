import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/detailed_widget/single_person_item.dart';

import '../models/credits_info_request.dart';

// Экран с самыми важными работниками съемочной группы
class AllCrewScreen extends StatefulWidget {
  static const routNamed = './allCrewRoute';
  const AllCrewScreen({Key? key}) : super(key: key);

  @override
  State<AllCrewScreen> createState() => _AllCrewScreenState();
}

class _AllCrewScreenState extends State<AllCrewScreen> {
  // принимаем карту с названием должности и списком людей на данной должности
  Map<String, List<Cast>>? _castMap;
  var _isLoading = false;
  // список для удобной работы с картой
  List<MapEntry<String, List<Cast>>> _listCast = [];

//инициализируем карту и список данными из аргументов навигатора
  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    _castMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, List<Cast>>?;
    _listCast = _castMap?.entries.toList() ?? [];
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
              // сперва проходим по всем ключам карты
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (_listCast[index].value.isNotEmpty) {
                    return createListView(
                      _listCast[index].value,
                      _listCast[index].key,
                      context,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                itemCount: _listCast.length,
              ),
            ),
    );
  }

  // виджет для создания одного скролл списка по должности
  Widget createListView(
      List<Cast> crewList, String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // выводим должность
          Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          // список людей на должности
          ListView.builder(
            itemBuilder: (context, index) {
              return SinglePersonItem(
                castPers: crewList[index],
                isActor: false,
                heroKey: '${title}_hero_$index',
              );
            },
            itemCount: crewList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
          ),
        ],
      ),
    );
  }

// виджет для создания карты одного работника

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
