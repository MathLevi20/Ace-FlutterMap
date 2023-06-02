import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
    return null; // ou alguma outra lógica de tratamento caso o usuário não esteja autenticado
  }

  late GoogleMapController mapController;
  late LatLng _center;
  late bool _isLoading = true;
  late bool _isLoading2 = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Set<Marker> markers = {};

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
      const ImageConfiguration(size: Size(60, 60)), // Tamanho do ícone
      "assets/images/Icon.png", // Caminho do arquivo de imagem
    );
    final icon_2 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 60)), // Tamanho do ícone
      "assets/images/iuse.png", // Caminho do arquivo de imagem
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
          icon: icon_2, // Altere a cor do ícone aqui

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
        icon: icon, // Altere a cor do ícone aqui

        infoWindow: const InfoWindow(
            title: 'IFPI-Central',
            snippet:
                "Instituição de ensino superior referência, formando profissionais capacitados."));
    Marker marcadorIfpiSul = Marker(
        markerId: const MarkerId('IFPI Sul'),
        position: const LatLng(-5.101723, -42.813114),
        icon: icon, // Altere a cor do ícone aqui
        draggable: true,
        infoWindow: const InfoWindow(
            title: 'IFPI-Sul',
            snippet:
                "Excelência educacional na zona sul, preparando futuros talentos."));
    markers.add(marcadorIfpi);
    markers.add(marcadorIfpiSul);
    print('Error retrieving markers: $markers');
    setState(() {
      _isLoading2 = false;
    });
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

  @override
  Widget build(BuildContext context) {
    // ignore: unrelated_type_equality_checks, unnecessary_null_comparison
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text("Google Maps"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      // Display a loading screen while waiting for location data
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text("Google Maps"),
        ),
        body: GoogleMap(
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
        ),
      );
    }
  }
}
