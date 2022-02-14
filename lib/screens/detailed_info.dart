import 'dart:ui';

import 'package:flutter/material.dart';

import '../providers/movie.dart';

class DetailedInfo extends StatefulWidget {
  const DetailedInfo({Key? key}) : super(key: key);
  static const routName = '/detailed_info';

  @override
  State<DetailedInfo> createState() => _DetailedInfoState();
}

class _DetailedInfoState extends State<DetailedInfo> {
  late double _myHeight;
  late double _myWidth;
  late double _imageHeight;
  late double _imageWidth;
  double _bottomSize = 170.0;
  late DraggableScrollableController _scrollController;

  @override
  void initState() {
    _scrollController = DraggableScrollableController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _myHeight = MediaQuery.of(context).size.height;
    _myWidth = MediaQuery.of(context).size.width;
    _imageHeight = _myHeight * 0.5;
    _imageWidth = _myWidth * 0.75;
    super.didChangeDependencies();
  }

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

  _changeSize({
    required double iHeight,
    required double iWidth,
  }) {
    setState(() {
      _imageHeight = _myHeight * iHeight;
      _imageWidth = _myWidth * iWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      appBar: AppBar(
        title: Text('${movie.title}'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: _myHeight * 0.85,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/original${movie.imageUrl}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 120),
                  bottom: _bottomSize,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: _imageWidth,
                    height: _imageHeight,
                    child: Image.network(
                        'https://image.tmdb.org/t/p/original${movie.imageUrl}'),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            controller: _scrollController,
            initialChildSize: 0.25,
            maxChildSize: 1,
            minChildSize: 0.05,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: scrollController,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
