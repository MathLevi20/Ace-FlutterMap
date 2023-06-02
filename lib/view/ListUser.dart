import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListUser createState() => _ListUser();
}

class _ListUser extends State<ListUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _locationLong = TextEditingController();
  final TextEditingController _locationLat = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final TextEditingController _locationLatController = TextEditingController();
  final TextEditingController _locationLongController = TextEditingController();

  late String uuid;

  String? getUserUID() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      return uid;
    }
    return null; // ou alguma outra lógica de tratamento caso o usuário não esteja autenticado
  }

  void _showEditDialog(String userId, String currentName,
      String currentDescription, String currentLat, String currentLong) {
    _name.text = currentName;
    _description.text = currentDescription;
    _locationLong.text = currentLong;
    _locationLat.text = currentLat;

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
            child: ListView(shrinkWrap: true, children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
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
                const SizedBox(height: 4.0),
                TextField(
                  controller: _locationLong,
                  decoration: const InputDecoration(
                    labelText: 'Localização Longitude',
                  ),
                ),
                const SizedBox(height: 4.0),
                TextField(
                  controller: _locationLat,
                  decoration: const InputDecoration(
                    labelText: 'Localização Latitude',
                  ),
                ),
              ]),
            ]),
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
                      controller: _locationLongController,
                      decoration: const InputDecoration(
                        labelText: 'Localização Longitude',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _locationLatController,
                      decoration: const InputDecoration(
                        labelText: 'Localização Latitude',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showCreateDialog();
                  },
                  child: const Text('Criar Usuário'),
                ),
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
                    final name = user['name'];
                    final long = user['long'];
                    final lat = user['lat'];
                    final description = user['description'];

                    return ListTile(
                        title: Text(name),
                        subtitle: Text('Long = $long,Lat = $lat'),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
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
                                  description, lat, long);
                            },
                          )
                        ]));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateUser(String userId) async {
    final name = _name.text;
    final description = _description.text;
    final long = double.parse(_locationLong.text);
    final lat = double.parse(_locationLat.text);

    await _firestore
        .collection('users')
        .doc(getUserUID())
        .collection('contact')
        .doc(userId)
        .update({
      'name': name,
      'description': description,
      'lat': lat,
      'long': long,
    });
    _name.clear();
    _description.clear();
    _locationLong.clear();
    _locationLat.clear();
  }

  void _createUser() async {
    final name = _nameController.text;
    final long = double.parse(_locationLongController.text);
    final lat = double.parse(_locationLatController.text);
    final description = _descriptionController.text;

    await _firestore
        .collection('users')
        .doc(getUserUID())
        .collection('contact')
        .add({
      'name': name,
      'description': description,
      'lat': lat,
      'long': long,
    });

    _nameController.clear();
    _descriptionController.clear();
    _locationLongController.clear();
    _locationLatController.clear();
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
