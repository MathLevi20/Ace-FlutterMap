import 'dart:ffi';
import 'package:geocoding/geocoding.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps/view/UsersProfileView.dart';


class ListUser extends StatefulWidget {
  const ListUser({Key? key});

  @override
  _ListUserState createState() => _ListUserState();
}

Future<List<double>> getCoordinatesFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;
      print(latitude);
      print(longitude);
      return [latitude, longitude];
    }
  } catch (e) {
    print('Erro ao obter as coordenadas: $e');
  }

  return [];
}

class _ListUserState extends State<ListUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final TextEditingController _address = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? getUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      return uid;
    }
    return null;
  }

  String? userUID;

  @override
  void initState() {
    super.initState();
    userUID = getUserUID();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      Color.fromARGB(255, 63, 0, 209),
      Color.fromARGB(255, 138, 0, 209)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato'),
        backgroundColor: Color.fromARGB(255, 63, 0, 209),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  const SizedBox(height: 4.0),
                  ElevatedButton(
                    onPressed: _showCreateDialog,
                    child: const Text('Criar Usuário'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(getUserUID())
                    .collection('contact')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index].data() as Map<String, dynamic>;
                      final name = user['name'] ?? "";
                      final description = user['description'] ?? "";
                      final address = user['address'] ?? "";
                      final phone = user['phone'] ?? "";
                      final email = user['email'] ?? "";

                      return Padding(
                          padding: const EdgeInsets.all(19.0),
                          child: Card(
                              child: ListTile(
                            title: Text(
                              name,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '$description',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                              ),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  profileUid: userUID!,
                                  profileId: users[index].id,
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteUser(users[index].id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(users[index].id, name,
                                        description, address, phone, email);
                                  },
                                ),
                              ],
                            ),
                          )));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    String userId,
    String? currentName,
    String? currentDescription,
    String? currentAddress,
    String? currentPhone,
    String? currentEmail,
  ) {
    _name.text = currentName ?? "";
    _description.text = currentDescription ?? "";
    _address.text = currentAddress ?? "";
    _phone.text = currentPhone ?? "";
    _email.text = currentEmail ?? "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Editar Usuário'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(1.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    TextField(
                      controller: _description,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _address,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUser(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Criar Usuário'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(1.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _createUser();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _updateUser(String userId) async {
    final name = _name.text;
    final description = _description.text;
    final address = _address.text;
    final phone = _phone.text;
    final email = _email.text;
    double? latitude;
    double? longitude;

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
        .doc(getUserUID())
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

    _name.clear();
    _description.clear();
    _address.clear();
    _email.clear();
    _phone.clear();
  }

  void _createUser() async {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;
    final email = _emailController.text;
    double? latitude;
    double? longitude;

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
        .doc(getUserUID())
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

    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  void _deleteUser(String userId) async {
    await _firestore
        .collection('users')
        .doc(getUserUID())
        .collection('contact')
        .doc(userId)
        .delete();
  }
}
