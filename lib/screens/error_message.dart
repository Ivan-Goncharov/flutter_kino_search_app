import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  static const routNamed = './errorScreen';
  const ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              // color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                child: Image.asset(
                  'assets/image/error_message.png',
                  color: Colors.white,
                ),
                fit: BoxFit.contain,
              ),
            ),
            const Text('Что-то пошло не так /n Приносим извинения'),
          ],
        ),
      ),
    );
  }
}
