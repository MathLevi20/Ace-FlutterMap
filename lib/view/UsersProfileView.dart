import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String profileId;
  final String profileUid;

  ProfileScreen({required this.profileId, required this.profileUid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String description = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String name = "";
  String address = "";
  String phone = "";
  String email = "";

  late GoogleMapController mapController;
  late LatLng _center;
  late bool _isLoading = true;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  List<LatLng> polylineCoordinates = [];

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void fetchUserProfile() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileUid)
        .collection('contact')
        .doc(widget.profileId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      final icon_3 = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(60, 60)), // Icon size
        "assets/images/arrow-new.png", // Image file path
      );

      if (data != null) {
        LatLng latLng = LatLng(data['lat'].toDouble(), data['long'].toDouble());

        print('Localização: $latLng');

        setState(() {
          _center = latLng;

          latitude = data['lat'];
          longitude = data['long'];
          name = data['name'] ?? "";
          description = data['description'] ?? "";
          address = data['address'] ?? "";
          phone = data['phone'] ?? "";
          email = data['email'] ?? "";
          _isLoading = false;
        });
        Marker user = Marker(
          markerId: MarkerId(data['name']),
          position: LatLng(data['lat'].toDouble(), data['long'].toDouble()),
          draggable: true,
          icon: icon_3,
          infoWindow: InfoWindow(
            title: data['name'],
            snippet: data['description'],
          ),
        );
        markers.add(user);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
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
        body: Center(
          child: Column(
            children: [
              Container(
                child: Expanded(
                  child: GoogleMap(
                      mapType: MapType.terrain,
                      compassEnabled: true,
                      indoorViewEnabled: true,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 17.0,
                      ),
                      markers: markers),
                ),
              ),
              Container(
                height: 220,
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.topCenter,
                child: Card(
                  color: Color.fromARGB(255, 63, 0, 209),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 210, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 16),
                          Text(
                            'Nome: ${name}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Descrição: ${description.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Telefone: ${phone}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Email: ${email}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Latitude: ${latitude}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Longitude: ${longitude}',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NeonTubes2',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_sharp), // Ícone do botão
            backgroundColor: Color.fromARGB(255, 63, 0, 209),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  5.0), // Set the desired radius for a square shape
            ), // Cor de fundo do botão
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      );
    }
  }
}
