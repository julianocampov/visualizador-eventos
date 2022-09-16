import 'dart:convert';

import '../user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class EventsServices {

  final ip = "http://sistemic.udea.edu.co:4000";
  final prefs = PreferenciasUsuario();

  Future<List<dynamic>> allEvents() async {
    var headers = {
      'Authorization': 'Bearer ${prefs.refreshToken}',
      'Cookie': 'color=rojo'
    };
    var request = http.Request('GET', Uri.parse('$ip/reto/events/eventos/listar'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final List<dynamic> decodeData = json.decode(await response.stream.bytesToString());
    
    return decodeData;
  }

  Future<List<dynamic>> zoneEvents(String zone) async{
    var headers = {
      'Authorization': 'Bearer ${prefs.refreshToken}',
      'Cookie': 'color=rojo; color=rojo'
    };
    var request = http.Request('GET', Uri.parse('$ip/reto/events/eventos/listar/zona/$zone'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List<dynamic> decodeData = json.decode(await response.stream.bytesToString());
    
    return decodeData;
  }

  Future<List<dynamic>> statusEvents(String status) async {
    var headers = {
      'Authorization': 'Bearer ${prefs.refreshToken}',
      'Cookie': 'color=rojo; color=rojo'
    };

    var request = http.Request('GET', Uri.parse('$ip/reto/events/eventos/listar/status/$status'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    
    final List<dynamic> decodeData = json.decode(await response.stream.bytesToString());
    
    return decodeData;
    
  }
}