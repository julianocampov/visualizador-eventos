import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:visualizador_eventos/services/events_services.dart';
import 'package:visualizador_eventos/widgets/sizedboxw_widget.dart';
import 'audio_widget.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final args =  (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final alerta = args['alerta'];
    final String imagen = _imagen(alerta["eventDescription"]);
    final eventsServices = EventsServices();

    String userId =  alerta['id'];
    String status;

    switch (alerta['status']) {
      case 1:
        status = "Activo";
        break;

      case 2:
        status = "Inactivo";
        break;

      default:
        status = "Descartado";
        break;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

              const Text(
                "Información de la alerta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(255, 192, 0, 10),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBoxWidget(heightSized: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/$imagen.png",
                    height : 30,
                    width  : 30,
                  ),
              
                  Text( 
                      " ${"${alerta['eventDescription']}".substring(0, 1).toUpperCase()}${"${alerta['eventDescription']}".substring(1).toLowerCase()}",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                ],
              ),
              
              
              Column(
                children: [
                  const Divider(color: Color.fromRGBO(255, 192, 0, 10)),
                  Text(
                    alerta['comment'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                ],
              ),

              const SizedBoxWidget(heightSized: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  const Text("Día: ", ),
                  Text(
                    "${alerta['date']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  const SizedBox(width: 60),
                  const Text("Hora: ", ),
                  Text(
                    "${alerta['time']}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
              const Divider(color: Color.fromRGBO(255, 192, 0, 10)),
              const SizedBoxWidget(heightSized: 5),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zona : "),
                  Text(
                    "${alerta['zoneCode']}",
                    style: const TextStyle(
                          fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),

              Text(
                status,
                style: TextStyle(
                  color: _getColor(status),
                  fontWeight: FontWeight.bold
                ),
              ),
              
              const Divider(color: Color.fromRGBO(255, 192, 0, 10)),
              const SizedBoxWidget(heightSized: 10),
      
              FutureBuilder(
                future: eventsServices.eventMedia(userId),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    
                    final data = snapshot.data!;
                    final fotos = data['photos'];
                    final audios = data['audios'];
                    if(!fotos.isEmpty && !audios.isEmpty){
                      return SafeArea(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width*0.9,
                              height: MediaQuery.of(context).size.height*0.6,
                              child: _showPhotos(fotos, context)
                              ),

                              const SizedBoxWidget(heightSized: 12),
                              Card(
                                child: Column(
                                  children: [
                                    const SizedBoxWidget(heightSized: 10),
                                    const Text(
                                      "Audio de lo ocurrido",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),

                                    ),
                                    const SizedBoxWidget(heightSized: 8),
                                    AudioWidget(audios: audios),
                                    const SizedBoxWidget(heightSized: 10),
                                  ],
                                ),
                              ),
                            const SizedBoxWidget(heightSized: 30),
                          ],
                        ),
                      );
                    }else if (!fotos.isEmpty && audios.isEmpty){
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.5,
                            child: _showPhotos(fotos, context)
                          ),

                          const SizedBoxWidget(heightSized: 30),
                        ]
                      );
                    } else if (fotos.isEmpty && !audios.isEmpty){
                      return Column(
                        children: [
                          const SizedBoxWidget(heightSized: 12),
                              Card(
                                child: Column(
                                  children: [
                                    const SizedBoxWidget(heightSized: 10),
                                    const Text(
                                      "Audio de lo ocurrido",
                                      style: TextStyle(
                                        fontSize: 17
                                      ),

                                    ),
                                    const SizedBoxWidget(heightSized: 8),
                                    AudioWidget(audios: audios),
                                    const SizedBoxWidget(heightSized: 10),
                                  ],
                                ),
                              ),
                            const SizedBoxWidget(heightSized: 30),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "No hay archivos multimedia disponibles",
                            style: TextStyle(
                              color: Colors.black38,
                            ),
                          )
                        ],
                      );
                    }
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
      ),
    );
  }

  Widget _showPhotos(List<dynamic> fotos, BuildContext context) {
    for (var foto in fotos) {
      //convert Base64 string to Uint8List
      Uint8List image = const Base64Decoder().convert(foto);

      return SizedBox(
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.memory(
            image,
          ),
        ),
      );
    }
    return const Text("No hay fotos disponibles");
  }
  
  _getColor(String status) {
   switch (status) {
      case "Activo":
        return Colors.green;
      case "Inactivo":
        return Colors.yellow;
      default:
         return Colors.red;
    }
  }
}

_imagen(String imagen){
  
  switch(imagen) { 
    case "ROBO": { 
        return "robo";
    } 
    case "ACCIDENTE": { 
        return "accidente-de-auto";
    }

    case "INCENDIO": { 
        return "extintor-de-incendios";
    }  

    case "ARMAS": { 
        return "armas-de-fuego";
    } 

    case "SUSTANCIAS": { 
        return "marihuana";
    } 

    case "DESLIZAMIENTO": { 
        return "deslizamiento-de-tierra";
    }

    case "OTROS": { 
        return "mas";
    }  

    default: { 
        return "advertencia";
    }
  } 
}