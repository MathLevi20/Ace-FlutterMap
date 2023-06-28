import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/ContactController.dart';
import '../../controller/MapController.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;
  late LatLng _center;
  late bool _isColumnVisible = false;
  late bool _isLoading = true;
  late PolylinePoints polylinePoints;

  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];

  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  void _toggleColumnVisibility() {
    setState(() {
      _isColumnVisible = !_isColumnVisible;
    });
  }

  Future<void> loadMarkers() async {
    Set<Marker> loadedMarkers = await mapController.carregarMarcadores(usercontroller.fetchUser());
    setState(() {
      markers = loadedMarkers;
    });
  }

  Future<void> getCurrentLocation() async {
    LatLng currentLocation = await mapController.getCurrentLocation();
    setState(() {
      _center = currentLocation;
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await mapController.requestLocationPermission();
    return status;
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMarkers();
    getCurrentLocation();
    requestLocationPermission();
  }

  void updatePolyline() async {
    String address1 = address1Controller.text;
    String address2 = address2Controller.text;
    Polyline? polyline = await mapController.onSearch(address1, address2);
    if (polyline != null) {
      setState(() {
        polylines.clear();
        polylines.add(polyline);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [
            Visibility(
              visible: _isColumnVisible,
              child: Container(
                margin: EdgeInsets.only(top: 35.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: address1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Partida',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 63, 0, 209),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 86, 86, 86),
                              width: 0.0,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 86, 86, 86),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: address2Controller,
                        decoration: InputDecoration(
                          labelText: 'Destino',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 63, 0, 209),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 86, 86, 86),
                              width: 0.0,
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 86, 86, 86),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: updatePolyline,
                      child: const Text('Procurar'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 63, 0, 209),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.terrain,
                compassEnabled: true,
                indoorViewEnabled: true,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: markers,
                polylines: polylines,
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 15.0),
          height: 50,
          width: 50,
          child: FloatingActionButton(
            onPressed: () {
              _toggleColumnVisibility();
            },
            child: Icon(Icons.search),
            backgroundColor: Color.fromARGB(255, 63, 0, 209),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
      );
    }
  }
}
