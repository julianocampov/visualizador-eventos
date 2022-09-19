import 'package:flutter/material.dart';
import 'package:visualizador_eventos/pages/visualizer_page.dart';

import '../widgets/perfil_widget.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(255, 192, 0, 10),
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
                    builder: (BuildContext context){
                      return const VisualizerPage();
                      },
                    ),  (Route<dynamic> route) => false,
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        //shadowColor: const Color.fromRGBO(255, 192, 0, 10),
      ),
      body: const PerfilWidget()
    );
  }
}