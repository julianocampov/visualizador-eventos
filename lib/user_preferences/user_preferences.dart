import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set token(String value){
    _prefs.setString('token', value);
  }

  set username(String value){
    _prefs.setString('username', value);
  }

  set name(String value){
    _prefs.setString('name', value);
  }

  set lastName(String value){
    _prefs.setString('lastName', value);
  }

  set refreshToken(String value){
    _prefs.setString('refreshToken', value);
  }

  String get token{
    return _prefs.getString('token') ?? "";
  }

  String get username{
    return _prefs.getString('username') ?? "";
  } 

  String get name{
    return _prefs.getString('name')  ?? "";
  }

  String get lastName{
    return _prefs.getString('lastName')  ?? "";
  }

  String get refreshToken{
    return _prefs.getString('refreshToken') ?? "";
  }

}