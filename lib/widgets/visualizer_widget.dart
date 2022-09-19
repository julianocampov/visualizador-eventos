import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:visualizador_eventos/services/events_services.dart';
import 'package:location/location.dart';

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
  bool inicializar = true;

  late GoogleMapController mapController;
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(_handleTabSelection);
    _handleTabSelection();
  }

  Future<void> _handleTabSelection() async {
    if (_tabController.indexIsChanging || inicializar) {
      inicializar = false;
      markers = {};
      contId = 0;

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          "assets/marker.png",
      );

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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
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
                  onTap: () {
                    Navigator.pushNamed(context, "detail", arguments: {'alerta' : element});
                  },
                  icon: markerbitmap,
                  position: LatLng(double.parse(element["location"][0].toString()), double.parse(element["location"][1].toString())),
                ));
              }
            });
          break;

          default: 
            markers = {};
            setState(() {
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
    _getlocation();

    return FutureBuilder(
      future: _loadLocation(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition : CameraPosition(
                target:  LatLng(double.parse(data['lat']), double.parse(data['lon'])),
                zoom: 12
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled :true,
              markers : markers,
              
            ),
          ),
          
          SizedBox(
            height: 42,  
            child: AppBar(
              backgroundColor: Colors.white,
              bottom: TabBar(
                indicator: const BoxDecoration(
                  color: Color.fromARGB(100, 255, 192, 0),
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

    );
  }

  _getlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<Map<String, dynamic>> _loadLocation() async {
    
    Location location = Location();
    LocationData locationData;
    Map<String, dynamic> loc = {};
    
    locationData = await location.getLocation();

    loc['lat'] = locationData.latitude.toString();
    loc['lon'] = locationData.longitude.toString();

    return loc;
  }
}

