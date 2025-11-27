import 'package:flutter/material.dart';
import 'package:plantas/view/login_page.dart';
import 'package:plantas/view/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void trocarPaginas() {
    setState(() => showLoginPage = !showLoginPage);
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: trocarPaginas);
    } else {
      return RegisterPage(onTap: trocarPaginas);
    }
  }
}