import 'package:flutter/material.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget.dart';

import '../services/ingreso_services.dart';
import '../user_preferences/user_preferences.dart';

class PerfilWidget extends StatelessWidget {
  const PerfilWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final prefs = PreferenciasUsuario();
    final ingresoServices = IngresoServices();
    
    return FutureBuilder(
      future: ingresoServices.seeProfile(prefs.refreshToken, prefs.username),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if(snapshot.hasData && snapshot.data!["error"] == null){
          final data = snapshot.data!;
          return Column(
            children: [
              const Text(
                "Información personal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 192, 0, 10),
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBoxWidget(heightSized: 10),

              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width*0.10,
                      color: const Color.fromARGB(170, 107, 107, 107),
                    ),
                    title: const Text('Usuario'),
                    subtitle: Text(data['username']),
                  ),
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.badge,
                      size: MediaQuery.of(context).size.width*0.10,
                      color: const Color.fromARGB(170, 107, 107, 107),
                    ),
                    title: const Text("Nombre y apellido"),
                    subtitle: _validateName(data['name'], data['lastName']),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      Icons.mail,
                      size: MediaQuery.of(context).size.width*0.10,
                      color: const Color.fromARGB(170, 107, 107, 107),
                    ),
                    title: const Text('Correo'),
                    subtitle:Text(data['email']),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Color.fromRGBO(255, 192, 0, 10),
                ),
              ],
            ),
          );
        }
      },
    );    
  }

  _validateName(String? name, String? lastName){
    if (name != "" && lastName != "") {
      return Text("$name $lastName");
    } else if (name != "" && lastName == ""){
      return Text(name!);
    } else if (name == "" && lastName != ""){
      return Text(lastName!);
    } else {
      return const Text('Edita en "configuración"');
    }
  }
}