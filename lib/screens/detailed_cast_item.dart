import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/providers/cast.dart';

import '../models/credits_info.dart';

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
  ItemCastInfo? _castInfo;
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _castInfo = ItemCastInfo(widget.castItem.id);
    _castInfo!.getCastInfo().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.castItem.id);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black26,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                top: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: widget.heroKey,
                    child: Image(
                      image: widget.castItem.getImage(),
                      height: MediaQuery.of(context).size.height * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Text(
                              '${widget.castItem.name}',
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
                                : Text('Загрузилось')
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
