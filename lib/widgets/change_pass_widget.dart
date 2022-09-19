import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget%20copy.dart';
import 'package:visualizador_eventos/widgets/textfield_widget.dart';
import '../services/ingreso_services.dart';
import '../user_preferences/user_preferences.dart';

class ChangePassWidget extends StatelessWidget {
  ChangePassWidget({super.key});

  final TextEditingController emailController = TextEditingController();
  final prefs = PreferenciasUsuario();
  final ingresoServices = IngresoServices();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width : double.infinity ,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Cambiar contraseña", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color : Color.fromRGBO(255, 192, 0, 10),
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),
              ),
        
              const SizedBoxWidget(heightSized: 10),
        
              const Text("Ingresa tu correo electrónico para enviar un código de verificación", 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color : Colors.black54,
                  fontSize: 17,
                ),
              ),
        
              const SizedBoxWidget(heightSized: 40),
              
              TextFieldWidget(label: "Ingresa tu correo", controllerText: emailController, isEmail : true),

              const SizedBoxWidget(heightSized: 60),

              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.55,
                  child: ElevatedButton(
                    onPressed: ()  async {
                        final Map<String, dynamic> datos = await ingresoServices.seeProfile(prefs.refreshToken, prefs.username);
                        if(await _verificarEmail(datos)){
                          if(await ingresoServices.codChangePass()){
                            Fluttertoast.showToast(
                              msg: "Código enviado al correo ingresado",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );

                            Navigator.pushNamed(context, "changePassf", arguments: {'email' : datos["email"]});

                          } 
                        } else {
                          Fluttertoast.showToast(
                            msg: "Correo inválido, verifica tu correo",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black87,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        }
                      },
                       
                      
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(255, 192, 0, 10),
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

              const SizedBoxWidget(heightSized: 60),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<bool> _verificarEmail(Map<String, dynamic> datos) async {
    if (emailController.text == datos["email"]){
      return true;
    }
    return false;
  }
}