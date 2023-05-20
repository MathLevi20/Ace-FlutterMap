import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


//class GoogleMap  extends StatelessWidget {
 // const GoogleMap ({Key? key});

  // This widget is the root of your application.
 // @override
  //Widget build(BuildContext context) {
    //return MaterialApp(
     // title: 'Flutter Demo',
   //   debugShowCheckedModeBanner: false,
     // theme: ThemeData(
       // colorScheme: ColorScheme.fromSwatch(
        //  primarySwatch: Colors.deepPurple,
        //
        //),
      //  useMaterial3: true,
     // ),
    //  home: const GoogleMaps(),
  //  );
  //}
//}

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({ Key? key
  });

  @override
  State<GoogleMaps> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMaps> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-5.088678196667846, -42.81117597299929);
  
  Set<Marker> markers = {};

  Future<void> _localizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Localização: $position');
  }

  void _carregarMarcadores() {
    Marker marcadorIfpi = const Marker(
      markerId: MarkerId('IFPI Central'),
      position: LatLng(-5.088544046019581, -42.81123803149089),
          draggable: true, infoWindow: InfoWindow(
    title: 'IFPI Zona Central',
    snippet: "IFPI Campus Teresina Zona Central: 15 anos de excelência em educação, formando líderes para o futuro!"
  )

      
    );
    Marker marcadorIfpiSul = const Marker(
      markerId: MarkerId('IFPI Sul'),
      position: LatLng(-5.101723, -42.813114),
      draggable: true, infoWindow: InfoWindow(
    title: 'IFPI Zona Sul',
    snippet: 'IFPI campus Teresina Zona Sul! 15 anos de educação gratuita e de qualidade!'
  )

    );
    markers.add(marcadorIfpi);
    markers.add(marcadorIfpiSul);
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
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
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