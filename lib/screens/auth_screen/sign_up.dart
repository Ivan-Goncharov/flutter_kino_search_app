import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatelessWidget {
  // контроллеры для полей ввода логина и пароля
  final _loginController = TextEditingController();
  final _passwordContoller = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  final VoidCallback onCklickedSignIn;

  SignUpPage({required this.onCklickedSignIn, Key? key}) : super(key: key);

  // метод для регитрации на firebase
  Future signUp(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    // если не прошли проверку, то возвращаем ошибку
    final isValid = globalKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _loginController.text.trim(),
        password: _passwordContoller.text.trim(),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // если пользователь с таким email уже есть, то показываем ошибку
      if (e.toString().contains('The email address is already')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Text(
              'Пользователь с таким email уже зарегистрирован',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        );
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  // cтиль текста для заголовков
  TextStyle _textStyle() {
    return const TextStyle(
      color: Colors.white54,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrHeight = MediaQuery.of(context).size.height;
    final scrWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(title: const Text('Регистрация'), centerTitle: true),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: scrHeight * 0.2,
                          width: scrWidth * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/image/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Поиск фильмов и сериалов',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    'Электронная почта',
                    style: _textStyle(),
                  ),
                  //  Ввод логина
                  Container(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 16,
                    ),
                    child: TextFormField(
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Введите корректный email'
                              : null,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: _loginController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _loginController.clear();
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
                      controller: _loginController,
                    ),
                  ),

                  Text(
                    'Пароль',
                    style: _textStyle(),
                  ),

                  //Ввод пароля
                  Container(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 16,
                    ),
                    child: TextFormField(
                      autocorrect: false,
                      obscureText: true,
                      enableSuggestions: false,
                      validator: (password) =>
                          password != null && password.length < 6
                              ? 'Длина пароля менее 6 символов'
                              : null,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: _passwordContoller.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _passwordContoller.clear();
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
                      controller: _passwordContoller,
                    ),
                  ),

                  //  кнопка войти
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            signUp(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: scrWidth * 0.45,
                            height: scrHeight * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Theme.of(context).colorScheme.secondary),
                            child: Text(
                              'Зарегистрироваться',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Есть аккаунт ?',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: onCklickedSignIn,
                        child:
                            const Text('Войти', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
