import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import '../model/User.dart';

class UserController {
  UserModel currentUser = UserModel.getCurrentUser() as UserModel;

  void deleteUser(String userId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .doc(userId)
        .delete();
  }

  void updateUser(String? userId, String name, String description,
      String address, String phone, String email) async {
    double? latitude;
    double? longitude;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
        print(latitude);
        print(longitude);
      }
    } catch (e) {
      print('Erro ao obter as coordenadas: $e');
    }

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .doc(userId)
        .update({
      'name': name,
      'description': description,
      'address': address,
      'lat': latitude,
      'long': longitude,
      'phone': phone,
      'email': email,
    });
  }

  void createUser(String name, String description, String address, String phone,
      String email) async {
    double? latitude;
    double? longitude;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .add({
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'lat': latitude,
      'long': longitude,
    });
  }

  Stream<QuerySnapshot<Object?>>? listUser() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .snapshots();
  }

  Future<DocumentSnapshot> fetchUserContact(String profileId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .doc(profileId)
        .get();

    return snapshot;
  }

  Future<QuerySnapshot> fetchUser() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('contact')
        .get();

    return snapshot;
  }
}

UserController usercontroller = UserController();
