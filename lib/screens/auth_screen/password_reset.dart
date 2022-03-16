import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_kino_app/widgets/system_widgets/error_message_widg.dart';

//Экран для сброса пароля
class ResetPasswordScreen extends StatefulWidget {
  static const routNamed = './resetPassword';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _emailController;

  bool _isError = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrHeight = MediaQuery.of(context).size.height;
    final scrWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      //убираем клаиватуру при нажатии на экран
      onTap: (() => FocusManager.instance.primaryFocus!.unfocus()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: const Text('Cброс пароля'), centerTitle: true),

        //проверяем на ошибку сети, если есть, то вызываем экран с ошибкой
        body: SingleChildScrollView(
          child: _isError
              ? ErrorMessageWidget(
                  handler: () => resetPassword(context),
                  size: MediaQuery.of(context).size)
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // поле для ввода email для сброса пароля
                      Text(
                        'Укажите email для сброса пароля',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 16,
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          //проверяем перед тем, как отправлять
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Введите корректный email'
                                  : null,
                          keyboardType: TextInputType.emailAddress,

                          //можно стереть введенные данные
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            suffixIcon: _emailController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _emailController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                    ),
                                  )
                                : const SizedBox(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          controller: _emailController,
                        ),
                      ),

                      //кнопка для отправки сообщения на email
                      GestureDetector(
                        onTap: (() {
                          resetPassword(context);
                          FocusManager.instance.primaryFocus!.unfocus();
                        }),
                        child: Container(
                          alignment: Alignment.center,
                          width: scrWidth * 0.6,
                          height: scrHeight * 0.07,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).colorScheme.secondary),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.mail_outlined,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Cбросить пароль',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  //метод для сброса пароля
  Future resetPassword(BuildContext context) async {
    setState(() => _isError = false);
    try {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      _showSnackBar(context, 'Отправлено письмо для сброса пароля');

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // если ошибка соединения, то вызываем экран с ошибкой
      if (e.toString().contains(' A network error')) {
        Navigator.of(context).pop();
        setState(() => _isError = true);
      } else {
        Navigator.of(context).pop();
        _showSnackBar(context, 'Пользователь с таким email не найден');
      }
    }
  }

  // метод для вывода сообщения об ошибке
  void _showSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(
          error,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
    );
  }
}
