import 'package:flutter/material.dart';

import '../../models/request_querry/credits_info_request.dart';
import '../../widgets/detailed_widget/single_person_item.dart';

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
        title: const Text('Съемочная группа'),
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
              // сперва проходим по всем ключам карты
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (_listCast[index].value.isNotEmpty) {
                    return ItemEmploye(
                      title: _listCast[index].key,
                      crewList: _listCast[index].value,
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
}

// виджет для создания одного скролл списка по должности
class ItemEmploye extends StatelessWidget {
  //заголовок должности
  final String title;
  //список работников
  final List<Cast> crewList;

  const ItemEmploye({Key? key, required this.title, required this.crewList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // выводим должность
          Text(title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium),
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
}
