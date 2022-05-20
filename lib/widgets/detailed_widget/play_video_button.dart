import 'package:flutter/material.dart';

import '../system_widgets/video_player.dart';

//кнопка для перехода на экран с воспроизведением трейлера
class PlayVideoButton extends StatelessWidget {
  //принимаем ключ видео
  final String keyVideo;
  const PlayVideoButton({Key? key, required this.keyVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //позиционирование в stack
    return Positioned(
      right: 55,
      bottom: 195,

      //иконка
      child: CircleAvatar(
        radius: 22,
        backgroundColor: const Color.fromARGB(255, 71, 70, 70),
        child: IconButton(
          icon: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 25,
          ),

          //обрабатываем нажатие
          onPressed: () {
            //проверяем - есть ли ключ
            keyVideo.isNotEmpty

                //если есть, то переходим на экран с воспроизведением
                ? Navigator.pushNamed(
                    context,
                    VideoPlayerScreen.routNamed,
                    arguments: keyVideo,
                  )

                //если нет, то выводим сообщение об отсуствии видео
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text(
                          'Ошибка',
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'Приносим наши извинения, видео не нашлось',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
