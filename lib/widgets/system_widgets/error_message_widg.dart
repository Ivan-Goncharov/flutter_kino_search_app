import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//виджет - сообщение об ошибке
//принимает функцию, которая вызывается про нажатии кнопки 'обновить'
// и размер, который будет использоваться для размера кнопки
class ErrorMessageWidget extends StatelessWidget {
  final VoidCallback handler;
  final Size size;
  const ErrorMessageWidget(
      {Key? key, required this.handler, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/animation_lottie/error_message.json',
            height: size.height * 0.25,
            width: size.width * 0.6,
          ),
          const Text(
            'У нас что-то сломалось',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Мы уже решаем проблему. Попробуйте обновить чуть позже',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: size.height * 0.05,
              width: size.width * 0.6,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(20, 20, 20, 1)),
                ),
                onPressed: handler,
                child: const Text('Обновить'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
