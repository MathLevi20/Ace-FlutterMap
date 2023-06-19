import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void fetchUserProfile() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.profileUid)
        .collection('contact')
        .doc(widget.profileId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          description = data['description'];
          latitude = data['lat'];
          longitude = data['long'];
          name = data['name'];
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'description: $description',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Longitude: $longitude',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Latitude: $latitude',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
