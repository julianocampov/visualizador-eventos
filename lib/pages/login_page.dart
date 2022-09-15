import 'package:flutter/material.dart';
import 'package:visualizador_eventos/widgets/login_wdiget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginWidget(),
    );
  }
}