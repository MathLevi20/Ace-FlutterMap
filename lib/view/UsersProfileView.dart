import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'UsersListView.dart';

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
        "assets/images/arrow.png", // Image file path
      );

      if (data != null) {
        LatLng latLng = LatLng(data['lat'].toDouble(), data['long'].toDouble());
        Marker user = Marker(
          markerId: const MarkerId('IFPI Central'),
          position: LatLng(data['lat'].toDouble(), data['long'].toDouble()),
          draggable: true,
          icon: icon_3,
          infoWindow: const InfoWindow(
            title: 'Levi',
            snippet:
                "Instituição de ensino superior referência, formando profissionais capacitados.",
          ),
        );
        markers.add(user);

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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text("Mapa"),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                    mapType: MapType.terrain,
                    compassEnabled: true,
                    indoorViewEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 17.0,
                    ),
                    markers: markers),
              ),
              Card(
                color: Color.fromARGB(255, 63, 0, 209),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 180, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        '${name.toUpperCase() ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${description.toUpperCase() ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${phone ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${email.toUpperCase() ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${latitude ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${longitude ?? ''}',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListUser()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFAE00FF),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: Colors.pinkAccent.withOpacity(0.8),
                          elevation: 4,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'NeonTubes2',
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
