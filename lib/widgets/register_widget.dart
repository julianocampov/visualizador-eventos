import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget.dart';
import 'package:visualizador_eventos/widgets/textfield_widget.dart';
import '../services/ingreso_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterWidget extends StatelessWidget {
  RegisterWidget({super.key});

  final TextEditingController userController    = TextEditingController();
  final TextEditingController passController    = TextEditingController();
  final TextEditingController repPassController = TextEditingController();
  final TextEditingController emailController   = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return SafeArea(                   
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(                  // Ordenar la inrmación
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Registrarse", 
              style: TextStyle(
                color : Color.fromRGBO(255, 192, 0, 10),
                fontSize: 50,
                fontWeight: FontWeight.bold
                ),
              ),

              const SizedBoxWidget(heightSized: 40),

              TextFieldWidget(label: "Usuario",              controllerText: userController),
              TextFieldWidget(label: "Correo" ,              controllerText: emailController, isEmail: true,),
              TextFieldWidget(label: "Contraseña",           controllerText: passController,  obscure: true,),
              TextFieldWidget(label: "Repita la contraseña", controllerText: repPassController,  obscure: true,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(255, 192, 0, 10),
                    ),
                    onPressed: () {
                      _tryRegister(context);                      
                    }, 
                    child: const Text(
                      "Registrarme",
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
                  const Text("¿Ya tienes una cuenta?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text(
                      "Iniciar sesisón", style: TextStyle(
                        color : Color.fromRGBO(255, 192, 0, 10),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validatePassword(String password, String repPassword) {
    if (password == repPassword) {
      return true;
    } else {
      return false;
    }
  }
  
  Future<void> _tryRegister(BuildContext context) async {

    final ingresoServices = IngresoServices();
    late Map<String, dynamic> decodeData;
    String textError = "";
    late http.StreamedResponse resp;

    if (_validatePassword(passController.text, repPassController.text)) {

      if(await ingresoServices.verifyUser(userController.text) == 1) {
         textError = "El usuario ya existe";
      } else if (await ingresoServices.verifyUser(userController.text) == 3){
        Fluttertoast.showToast(
        msg: "Problemas con el servidor",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
        );
      } else {
        resp = await ingresoServices.register(
        userController.text, 
        emailController.text,
        passController.text); 

        try {
          decodeData = json.decode(await resp.stream.bytesToString());
          textError = decodeData["errors"][0]["defaultMessage"];
        } catch (e) {
          print(e);
        }

        if (resp.statusCode == 201) {
          Navigator.pushNamed(
            context, 
            "otp",
            arguments: [
              emailController.text,
              userController.text
            ]
          );
          textError = "Valida tu correo";
        } else if (resp.statusCode == 409) {
          textError = decodeData["message"];
        }
      }
      Fluttertoast.showToast(
        msg: textError,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
        msg: "Las constraseñas no coinciden",
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