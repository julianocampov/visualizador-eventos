import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visualizador_eventos/pages/visualizer_page.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget%20copy.dart';
import 'package:visualizador_eventos/widgets/textfield_widget.dart';

import '../services/ingreso_services.dart';

class ChangePassFWidget extends StatelessWidget {
  ChangePassFWidget({super.key});

  final TextEditingController codeController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController repPassController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final ingresoServices = IngresoServices();

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 2,
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Column(
                children: [
                  const SizedBoxWidget(heightSized: 10),
                  const Text("Ingresa el código", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color : Color.fromRGBO(255, 192, 0, 10),
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                  
                        const SizedBoxWidget(heightSized: 10),
                  
                        Text("Código enviado a: \n${args['email']}", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color : Colors.black54,
                            fontSize: 17,
                          ),
                        ),
                  
                        const SizedBoxWidget(heightSized: 20),
                  
                        TextFieldWidget(label: "Ingresa el codigo", controllerText: codeController, isPhone: true),
                        const SizedBoxWidget(heightSized: 10),
                      ],
                    ),
                  ),
            
                  const SizedBoxWidget(heightSized: 20),

                  Card(
                    elevation: 2,
                    shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      children: [
                        const SizedBoxWidget(heightSized: 10), 
                        const Text("Nueva contraseña", 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color : Color.fromRGBO(255, 192, 0, 10),
                            fontSize: 35,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        const SizedBoxWidget(heightSized: 10),  
                        TextFieldWidget(label: "Nueva contraseña", controllerText: passController, obscure: true,),
                        TextFieldWidget(label: "Repita la contraseña", controllerText: repPassController, obscure: true),
                        const SizedBoxWidget(heightSized: 30), 

                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.55,
                          child: ElevatedButton(
                            onPressed: ()  async {
                              if(_validatePass(passController.text , repPassController.text, codeController.text)){
                                if(await ingresoServices.changePass(passController.text, codeController.text)){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
                                    builder: (BuildContext context){
                                      return const VisualizerPage();
                                      },
                                    ),  (Route<dynamic> route) => false,
                                  );
                                }
                                
                              }
                            },
                       
                      
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(255, 192, 0, 10),
                            ),
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                        const SizedBoxWidget(heightSized: 40),  

                      ],
                    ),
                  ),     
          ],
        ),
      ),
    );
  }
  
  bool _validatePass(String pass, String repPass, String code) {
    if (pass.isEmpty || repPass.isEmpty || code.isEmpty){
      Fluttertoast.showToast(
        msg: "Algún campo está vacío",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return false;
    }
    else if(!(pass == repPass)){
      Fluttertoast.showToast(
        msg: "Las contraseñas no coinciden",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return false;
    } else {
      return true;
    }
  }
}