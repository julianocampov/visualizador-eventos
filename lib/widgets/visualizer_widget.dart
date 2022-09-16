import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visualizador_eventos/services/events_services.dart';

class MapaWidget extends StatefulWidget {
  const MapaWidget({super.key});

  @override
  State<MapaWidget> createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> with SingleTickerProviderStateMixin {
  
  Set<Marker> markers = {};
  final eventsServices = EventsServices();

  late TabController _tabController;
  late List<dynamic> allEvents;
  late int contId = 0;

  late GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(_handleTabSelection);
  }

  Future<void> _handleTabSelection() async {
    if (_tabController.indexIsChanging) {
      markers = {};
      contId = 0;
      switch (_tabController.index) {
        case 0:
            allEvents = await eventsServices.allEvents();
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;
        case 1:
          allEvents = await eventsServices.zoneEvents("0");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 2:
          allEvents = await eventsServices.zoneEvents("2");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 3:
          allEvents = await eventsServices.statusEvents("1");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 4:
          allEvents = await eventsServices.statusEvents("2");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          case 5:
          allEvents = await eventsServices.statusEvents("3");
            setState(() {
              for (var element in allEvents) {
                contId++;
                markers.add(Marker(
                  markerId: MarkerId(contId.toString()),
                  onDrag: null,
                  onDragStart: null,
                  infoWindow: InfoWindow(title: element["comment"]),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;
      } 
    } else {
        markers = {};
        contId  = 0;
      }
  }

  @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition : const CameraPosition(
              target:  LatLng(6.2448313, -75.5555744),
              zoom: 12
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled :true,
            markers : markers,
            
          ),
        ),
        
        SizedBox(
          height: 50,  
          child: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: const Color.fromARGB(100, 255, 192, 0),
              ),
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  height: 30,
                  child: Image.asset(
                    'assets/all.png',
                  ),
                ),
                Tab(
                  height: 40,
                  child: Image.asset(
                    'assets/zona_1.png',
                  ),
                ),
                Tab(
                  height: 40,
                  child: Image.asset(
                    'assets/zona_2.png',
                  ),
                ),
                Tab(
                  height: 30,
                  child: Image.asset(
                    'assets/activo.png',
                  ),
                ),
                Tab(
                  height: 30,
                  child: Image.asset(
                    'assets/inactivo.png',
                  ),
                ),
                Tab(
                  height: 30,
                  child: Image.asset(
                    'assets/descartado.png',
                  ),
                ),
                Tab(
                  height: 30,
                  child: Image.asset(
                    'assets/sin_evento.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}