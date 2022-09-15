import 'package:flutter/material.dart';
import '../user_preferences/user_preferences.dart';
import '../widgets/visualizer_widget.dart';
import 'login_page.dart';

class VisualizerPage extends StatefulWidget {
  const VisualizerPage({super.key});

  @override
  State<VisualizerPage> createState() => _VisualizerPageState();
}

class _VisualizerPageState extends State<VisualizerPage> {

  @override
  Widget build(BuildContext context) {
    
    final prefs = PreferenciasUsuario();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
         appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: const Color.fromRGBO(255, 192, 0, 10),
              title: const Text(
                "Visualizador de eventos",
                style: TextStyle(
                  color: Color.fromRGBO(255, 192, 0, 10),
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                          value: 0,
                          child: Text("Ver perfil"),
                      ),
      
                      const PopupMenuItem<int>(
                          value: 1,
                          child: Text("Configuración"),
                      ),
      
                      const PopupMenuItem<int>(
                          value: 2,
                          child: Text("Cerrar sesión"),
                      ),
                    ];
                  },
                  
                  onSelected:(value){
                    if(value == 0){
                      //Navigator.pushNamed(context, "perfil");
                    }else if(value == 1){
                      //Navigator.pushNamed(context, "config");
                    }else if(value == 2){
                      prefs.token = "";
                      prefs.refreshToken = "";
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
                        builder: (BuildContext context){
                          return const LoginPage();
                          },
                        ),  (Route<dynamic> route) => false,
                      );
                    }
                  },
                
                  icon: const Icon(Icons.more_vert, color: Color.fromRGBO(255, 192, 0, 10)),   
                  
                ) ,
              ]
            ),
        body: MapaWidget(),
      ),
    );
  }
}