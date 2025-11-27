import 'package:flutter/material.dart';
import 'package:plantas/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.green)),
    );

    try {
      await _authService.login(
        email: emailController.text.trim(),
        senha: passwordController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF66BB6A),
              Color.fromARGB(255, 0, 108, 248),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white30),
              ),
              child: Column(
                children: [
                  const Icon(Icons.spa,
                      size: 95, color: Colors.white),

                  const SizedBox(height: 20),

                  const Text(
                    "Herbário",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Senha",
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon:
                          const Icon(Icons.lock, color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: signUserIn,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.green[900],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Não tem conta? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Registre-se",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
