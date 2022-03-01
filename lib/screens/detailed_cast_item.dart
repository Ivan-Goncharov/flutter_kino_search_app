import 'package:flutter/material.dart';

import '../models/credits_info.dart';

class DetailedCastInfo extends StatefulWidget {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.castItem.name),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: widget.heroKey,
                child: Image(
                  image: widget.castItem.getImage(),
                  height: MediaQuery.of(context).size.height * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
