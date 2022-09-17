import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_eventos/services/events_services.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final alerta = args['alerta'];
    final eventsServices = EventsServices();

    eventsServices.eventMedia(alerta['userId']);


    return Column(
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

        Text("UserID: ${alerta['userId']}"),
        
      ]
    );
  }
}