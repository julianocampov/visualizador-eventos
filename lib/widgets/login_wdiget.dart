import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget.dart';
import 'package:visualizador_eventos/widgets/textfield_widget.dart';
import '../pages/visualizer_page.dart';
import '../services/ingreso_services.dart';
import '../user_preferences/user_preferences.dart';


class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final prefs = PreferenciasUsuario();
    print("PRIMERO: ${prefs.token}");

    if (prefs.token.isNotEmpty){
      Future.delayed(Duration.zero,(){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
          builder: (BuildContext context){
            return VisualizerPage();
            },
          ),  (Route<dynamic> route) => false,
        );
      },
    );
    } else {
      return SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const SizedBoxWidget(heightSized: 100),

                const Image(
                  image: AssetImage("assets/logo.png"),
                ),

                const SizedBoxWidget(heightSized: 15),

                const Text(
                  "Visualizador de eventos", 
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto'
                  ),
                ),
                
                const SizedBoxWidget(heightSized: 40),

                TextFieldWidget(
                  label: "Usuario", 
                  controllerText: userController
                ),

                TextFieldWidget(
                  label: "Contraseña", 
                  controllerText: passController,
                  obscure: true,
                ),
                
                const SizedBoxWidget(heightSized: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(255, 192, 0, 10),
                      ),
                      onPressed: ()  {
                        _tryLogin(context);
                      }, 
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "register");
                      }, 
                      child: const Text(
                        "Regístrate",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 192, 0, 10),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                        ),
                      )
                    )
                  ],
                )
              ],
            )
          ),
        )
      );
    } return Column();
  }
  
  Future<void> _tryLogin(BuildContext context) async {

    final ingresoServices = IngresoServices();
    String textError = "";
    
    if (userController.text != "" && passController.text != "") {
      if(await ingresoServices.verifyUser(userController.text) == 1) {
        Map<String, dynamic> res  = await ingresoServices.login(userController.text, passController.text);

        if ( res["error"] == null) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
            builder: (BuildContext context){
              return const VisualizerPage();
              },
            ),  (Route<dynamic> route) => false,
          );
        } else {
          if(res["error_description"] == "Bad credentials") {
            textError = "Credenciales incorrectas";
          }
        }
      } else if (await ingresoServices.verifyUser(passController.text) == 2){
        textError = "Credenciales incorrectas";
      } else {
        textError = "Problemas con el servidor";
      }
    } else {
      textError = "Algún campo está vacío";
    }

    if (textError != "") {
      Fluttertoast.showToast(
        msg: textError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  } 
}
