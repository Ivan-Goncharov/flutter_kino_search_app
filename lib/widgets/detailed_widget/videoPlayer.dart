import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../providers/movie.dart';

// Видео плеер, который использует пакет youtube_player_flutter
class VideoPlayerScreen extends StatefulWidget {
  static const routNamed = './videoPlayer';
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  // получаем наш фильм через аргументы навигации
  late Movie _movie;
  // контроллер для получения видео с платформы Youtube
  late YoutubePlayerController _controller;

  @override
  void didChangeDependencies() {
    //инициализруем данные о фильме
    _movie = ModalRoute.of(context)!.settings.arguments as Movie;
    // создаем контроллер, передаем ключ от видео трейлера
    _controller = _controller = YoutubePlayerController(
      initialVideoId: _movie.keyVideo,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // используем Builder, чтобы поддерживать полноэкранный просмотр
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(
            '${_movie.title}: Трейлер',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: player,
        ),
      ),
    );
  }
}