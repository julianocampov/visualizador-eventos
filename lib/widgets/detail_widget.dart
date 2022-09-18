import 'dart:convert';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_eventos/services/events_services.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final alerta = args['alerta'];
    final eventsServices = EventsServices();

    String user_id =  alerta['id'];

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Información de la alerta",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 192, 0, 10),
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            Text(alerta['eventDescription']),
      
            Text(alerta['comment']),
      
            Text("dia: ${alerta['date']}"),
      
            Text("hora: ${alerta['time']}"),
      
            Text("latitud: ${alerta['location'][0].toString()} , longitud: ${alerta['location'][1].toString()}"),
      
            Text(alerta['zoneCode'].toString()),
      
            Text("UserID: ${alerta['id']}"),
      
            FutureBuilder(
              future: eventsServices.eventMedia(user_id),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasData) {
                  bool isPlaying = false;
                  final audioPlayer = AudioPlayer();

                  Duration duration = Duration.zero;
                  Duration position = Duration.zero;
                  final data = snapshot.data!;
                  final fotos = data['photos'];
                  final audios = data['audios'];
                  final videos = data['videos'];
                  return SafeArea(
                    child: Column(
                      children: [
                        _showPhotos(fotos),
                        
                      ],
                    ),
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
              }
      
      
            )
            
          ]
        ),
      ),
    );
  }
  
  Widget _showPhotos(List<dynamic> fotos) {
    for (var foto in fotos) {
      //convert Base64 string to Uint8List
      Uint8List image = const Base64Decoder().convert(foto);

      return Container(
        height: 240,
        width: 240,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.memory(
            image,
            width: 240,
            height: 240,
          ),
        ),
      );
    }

    return Text("No hay fotos");
  }
}
