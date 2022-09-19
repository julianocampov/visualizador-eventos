import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../pages/login_page.dart';
import '../services/ingreso_services.dart';

class OTPWidget extends StatelessWidget {
  const OTPWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final List<String> args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return PinCodeVerificationScreen(
      emailAddr : args[0],
      username  : args[1]
    );
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String? emailAddr;
  final String? username;

  const PinCodeVerificationScreen({
    Key? key,
    this.emailAddr, 
    this.username,
  }) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  final ingresoServices = IngresoServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height : MediaQuery.of(context).size.height,
          width  : MediaQuery.of(context).size.width,
          child  : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Revisa tu correo",
                  style: TextStyle(
                  color : Color.fromRGBO(255, 192, 0, 10),
                    fontWeight: FontWeight.bold, 
                    fontSize: 40,
                    fontFamily: 'Roboto'
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                    text: "Enviamos un codigo de verificación a: ",
                    children: [
                      TextSpan(
                          text: "${widget.emailAddr}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 18,
                      fontFamily: 'Roboto'
                    )
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 50),
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.grey,
                      selectedFillColor:  Colors.white,
                      selectedColor:  const Color.fromRGBO(255, 192, 0, 10),
                      shape: PinCodeFieldShape.box,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(4),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      debugPrint(currentText);
                      debugPrint("${widget.username}");

                      String res = await ingresoServices.otp(currentText, "${widget.username}");
                      print(res);

                      if (res == "badCode") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else if (res == "confirm") {
                        setState(() {
                            hasError = false;
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
                              builder: (BuildContext context){
                                return const LoginPage();
                                },
                              ),  (Route<dynamic> route) => false,
                            );
                            Fluttertoast.showToast(
                              msg: "Registro exitoso",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: 16.0
                            );
                          },
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Problemas del servidor",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      }
                    },
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        hasError = false;
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      debugPrint("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      
                      return false;
                    },
                  )
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: TextButton(
                      child: const Text(
                        "Limpiar",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 192, 0, 10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        textEditingController.clear();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}