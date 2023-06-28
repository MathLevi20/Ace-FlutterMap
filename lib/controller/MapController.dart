import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'ContactController.dart';

class MapController {
  late LatLng center;

  Future<dynamic> carregarMarcadores(dynamic user) async {
    Set<Marker> markers = {};

    final icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 60)), // Icon size
      "assets/images/Icon.png", // Image file path
    );
    final icon_2 = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(60, 60)), // Icon size
      "assets/images/arrow-new.png", // Image file path
    );

    try {
      var querySnapshot = await user;
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
    print(' $markers');
    return markers;
  }

  Future<dynamic> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Localização: $LatLng(position.latitude, position.longitude)');

      return center = LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      print('Location permission denied by the user');
    }
  }

  Future<Polyline?> onSearch(String address1, String address2) async {
    // Perform geocoding to get the coordinates of the addresses
    List<Location> locations1 = await locationFromAddress(address1);
    List<Location> locations2 = await locationFromAddress(address2);

    if (locations1.isEmpty || locations2.isEmpty) {
      print('Geocoding failed for one or both addresses');
      return null;
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

    // Create and return the polyline
    return Polyline(
      polylineId: const PolylineId('route'),
      color: Color.fromARGB(255, 63, 0, 209),
      points: routeCoordinates,
      width: 4,
      visible: true,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    );
  }
}

MapController mapController = MapController();
