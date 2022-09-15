import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../user_preferences/user_preferences.dart';

class IngresoServices {

  final ip = "http://sistemic.udea.edu.co:4000";
  final prefs = PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String user, String password) async {
    var headers = {
      'Authorization': 'Basic Zmx1dHRlci1yZXRvOnVkZWE=',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Cookie': 'color=rojo'
    };

    var request = http.Request('POST', Uri.parse('$ip/reto/autenticacion/oauth/token'));

    request.bodyFields = {
      'username'   : user,
      'password'   : password,
      'grant_type' : 'password'
    };

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final Map<String, dynamic> decodeData = json.decode(await response.stream.bytesToString());
  
    
    if (response.statusCode == 200) {
      
      prefs.token        = decodeData["access_token"];
      print("OEEEEEEEEEEEEEEEEEE");
      prefs.refreshToken = decodeData["refresh_token"];
      prefs.username     = user;
    }
    return decodeData;
  }

    Future<http.StreamedResponse> register(String user, String email, String password) async {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$ip/reto/usuarios/registro/enviar'));
      request.body = json.encode({
        "username": user,
        "password": password,
        "email": email
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      
      return response;
    }

    Future<String> otp(String code, String user) async {
      var request = http.MultipartRequest('POST', Uri.parse('$ip/reto/usuarios/registro/confirmar/$user'));
      request.fields.addAll({
        'codigo': code
      });

      http.StreamedResponse response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 201) {
        print(await response.stream.bytesToString());
        return "confirm";
      } else if (response.statusCode == 406) {
        return "badCode";
      } else {
        print(response.reasonPhrase);
      }
      return "error";
    }

    Future addContacts(String name, String lastName, String email, String cell, String user, String token) async {
      var headers = {
        'Authorization' : 'Bearer $token',
        'Content-Type'  : 'application/json'
      };

      var request = http.Request('POST', Uri.parse('$ip/reto/usuarios/contactos/crear/$user'));
      request.body = json.encode({
        "name"     : name,
        "lastName" : lastName,
        "email"    : email,
        "cellPhone": cell
      });
      request.headers.addAll(headers);
      try {
      http.StreamedResponse response = await request.send();
      print("${response.statusCode}");
        if (response.statusCode == 201) {
          print(await response.stream.bytesToString());
          Fluttertoast.showToast(
            msg: "Contacto creado correctamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
        );
        }

       else {
        print(response.reasonPhrase);        
        Fluttertoast.showToast(
          msg: "No fue posible crear el contacto",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Problemas con el servidor",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //return false;
    }
  }

  Future<Map<String, dynamic>> seeProfile(String token, String user) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Cookie': 'color=rojo'
    };
    var request = http.Request('GET', Uri.parse('$ip/reto/usuarios/usuarios/encontrar/$user'));

    request.headers.addAll(headers);

    
    try {
      http.StreamedResponse response = await request.send();
      final Map<String, dynamic> decodeData = await json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        prefs.name     = decodeData['name'];
        prefs.lastName = decodeData['lastName'];

        return decodeData;
      }
      else {
        print(response.reasonPhrase);
        return decodeData;
      }
    } catch (e) {
      final Map<String, dynamic> errorMap = {"error": "Problema de servidor"};
      print(e);
      Fluttertoast.showToast(
          msg: "Problemas con el servidor",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return errorMap;
    }
  }

  Future<int> verifyUser(String user) async {
    print(user);
    var headers = {
      'Cookie': 'color=rojo'
    };
    var request = http.MultipartRequest('GET', Uri.parse('$ip/reto/usuarios/usuarios/preguntar/usuarioExiste'));
    request.fields.addAll({
      'username': user
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      if (await response.stream.bytesToString() == "true") {
        return 1;
      } else {
        return 2;
      }
    }
    else {
      print(response.reasonPhrase);
    }
    return 3;
  }

  Future editProfile(String user, String name, String lastName, String token) async { 
 
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type' : 'application/json',
      'Cookie': 'color=rojo'
    };

    var request = http.Request('PUT', Uri.parse('$ip/reto/usuarios/usuarios/editar/$user'));
    request.body = json.encode({
      "name"     : name,
      "lastName" : lastName
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      Fluttertoast.showToast(
          msg: "Cambios realizados correctamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
        );
    }
    else {
      print(response.reasonPhrase);
      Fluttertoast.showToast(
          msg: "No fue posible realizar los cambios",
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