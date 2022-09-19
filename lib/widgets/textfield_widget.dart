import 'package:flutter/material.dart';

import '../user_preferences/user_preferences.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({super.key, required this.label, this.obscure = false, required this.controllerText, this.isEmail = false, this.isPhone = false, this.isEditName = false, this.isEditUserName = false, this.isEditLastName = false});

  final String label;
  final bool obscure;
  final TextEditingController controllerText;
  final bool isEmail;
  final bool isPhone;
  final bool isEditName;
  final bool isEditUserName;
  final bool isEditLastName;

  @override
  Widget build(BuildContext context) {
    
    final prefs = PreferenciasUsuario();
    if(isEditUserName){
      controllerText.text = prefs.username;
    }

    if(isEditName){
      controllerText.text = prefs.name;
    }

    if(isEditLastName){
      controllerText.text = prefs.lastName;
    }

    return Padding(  
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        enabled: isEditUserName ? false : true,
        keyboardType: _validateType(isEmail, isPhone)    ,   //_validateType(isEmail),
        cursorColor: Colors.black45,
        controller: controllerText,
        style: TextStyle(
          color: isEditUserName ? Colors.black26 : Colors.black87,
        ),
        obscureText: obscure,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(          
            borderSide: BorderSide(color: Color.fromRGBO(255, 192, 0, 10))
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}

_validateType(bool isEmail, bool isPhone){
  if (isEmail){
    return TextInputType.emailAddress;
  } else if (isPhone) {
    return TextInputType.phone;
  } else {
    return null;
  }
}