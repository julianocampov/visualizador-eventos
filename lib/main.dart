import 'package:flutter/material.dart';
import 'package:visualizador_eventos/pages/detail_page.dart';
import 'package:visualizador_eventos/pages/login_page.dart';
import 'package:visualizador_eventos/pages/register_page.dart';
import 'package:visualizador_eventos/pages/visualizer_page.dart';
import 'package:visualizador_eventos/user_preferences/user_preferences.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visualizador de eventos',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: "login",
      routes: {
        "visualizer"  : (context) =>  const VisualizerPage(),
        "login"       : (context) =>  const LoginPage(),
        "register"    : (context) =>  const RegisterPage(),
        "detail"    : (context) =>  const DetailPage(),
      },
    );
  }
}