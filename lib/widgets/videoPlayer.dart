import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatelessWidget {
  final String movieKey;
  VideoPlayer(this.movieKey);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: movieKey,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
        ),
      ),
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blue,
      progressColors: const ProgressBarColors(
          playedColor: Colors.blue, handleColor: Colors.blueAccent),
    );
  }
}
