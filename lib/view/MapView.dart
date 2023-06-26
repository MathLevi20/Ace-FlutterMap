import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key});

  @override
  State<GoogleMaps> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMaps> {
  String? getUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      return uid;
    }
    return null; // or any other logic to handle when the user is not authenticated
  }

  late GoogleMapController mapController;
  late LatLng _center;
  late bool _isLoading = true;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  Future<void> _localizacaoAtual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng latLng = LatLng(position.latitude, position.longitude);
      print('Localização: $latLng');
      setState(() {
        _center = latLng;
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _carregarMarcadores() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 60)), // Icon size
      "assets/images/Icon.png", // Image file path
    );
    final icon_2 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 60)), // Icon size
      "assets/images/arrow-new.png", // Image file path
    );

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getUserUID())
          .collection('contact')
          .get();
      print(querySnapshot);
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        final Map<String, dynamic> point =
            document.data() as Map<String, dynamic>;
        final double latitude = point['lat'].toDouble();
        final double longitude = point['long'].toDouble();
        final LatLng position = LatLng(latitude, longitude);
        final Marker marker = Marker(
          markerId: MarkerId(point['name']),
          position: position,
          icon: icon_2,
          infoWindow: InfoWindow(
            title: point['name'],
            snippet: point['description'],
          ),
        );
        markers.add(marker);
      });
    } catch (e) {
      print('Error retrieving markers: $e');
    }
    Marker marcadorIfpi = Marker(
      markerId: const MarkerId('IFPI Central'),
      position: const LatLng(-5.088544046019581, -42.81123803149089),
      draggable: true,
      icon: icon,
      infoWindow: const InfoWindow(
        title: 'IFPI-Central',
        snippet:
            "Instituição de ensino superior referência, formando profissionais capacitados.",
      ),
    );
    Marker marcadorIfpiSul = Marker(
      markerId: const MarkerId('IFPI Sul'),
      position: const LatLng(-5.101723, -42.813114),
      icon: icon,
      draggable: true,
      infoWindow: const InfoWindow(
        title: 'IFPI-Sul',
        snippet:
            "Excelência educacional na zona sul, preparando futuros talentos.",
      ),
    );
    markers.add(marcadorIfpi);
    markers.add(marcadorIfpiSul);
    print('Error retrieving markers: $markers');

  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      // handle the case where the user denied the permission
    }
  }

  @override
  void initState() {
    super.initState();
    _localizacaoAtual();
    _carregarMarcadores();
    _requestLocationPermission();
    _localizacaoAtual();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onSearchButtonPressed() async {
    String address1 = address1Controller.text;
    String address2 = address2Controller.text;

    // Perform geocoding to get the coordinates of the addresses
    List<Location> locations1 = await locationFromAddress(address1);
    List<Location> locations2 = await locationFromAddress(address2);

    if (locations1.isEmpty || locations2.isEmpty) {
      // Handle case where address geocoding failed
      return;
    }

    // Get the coordinates of the addresses
    LatLng position1 = LatLng(
      locations1[0].latitude,
      locations1[0].longitude,
    );
    LatLng position2 = LatLng(
      locations2[0].latitude,
      locations2[0].longitude,
    );

    // Perform route calculation using the coordinates
    // Replace this with your own route calculation logic
    List<LatLng> routeCoordinates = [
      position1,
      position2,
    ];

    setState(() {
      // Clear previous polylines
      polylines.clear();

      // Add the new route polyline
      polylines.add(
        Polyline(
            polylineId: const PolylineId('route'),
            color: Color.fromARGB(255, 63, 0, 209),
            points: routeCoordinates,
            width: 4,
            visible: true,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap),
      );
    });
  }

  late bool _isColumnVisible = false;

  void _toggleColumnVisibility() {
    setState(() {
      _isColumnVisible = !_isColumnVisible;
    });
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
                
                margin: EdgeInsets.only(top:35.0),
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
                                width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 86, 86, 86),
                                width: 0.0),
                          ),
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
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
                                width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 86, 86, 86),
                                width: 0.0),
                          ),
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onSearchButtonPressed,
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
            child: Icon(Icons.search), // Ícone do botão
            backgroundColor: Color.fromARGB(255, 63, 0, 209),
            // Cor de fundo do botão
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
      );
    }
  }
}
