import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantas/view/home_page.dart';
import 'package:plantas/view/login_or_register_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
