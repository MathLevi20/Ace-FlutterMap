import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maps/controller/ContactController.dart';
import 'package:maps/view/Contacts/ContactsProfileView.dart';

import '../../model/User.dart';

class ListContactsScreen extends StatefulWidget {
  const ListContactsScreen({Key? key});

  @override
  _ListContactsState createState() => _ListContactsState();
}


class _ListContactsState extends State<ListContactsScreen> {
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

  String? userUID;
  UserModel currentUser = userModel.getCurrentUser() as UserModel;

  @override
  void initState() {
    super.initState();
    userUID = currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      Color.fromARGB(255, 171, 4, 255),
      Color.fromARGB(255, 138, 0, 209),
      Color.fromARGB(255, 63, 0, 209),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 63, 0, 209),
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
                    child: const Text(
                      'Criar Usuário',
                      textAlign: TextAlign.center, // Centralizar o título
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 0, 174),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: usercontroller.listUser(),
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
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                color: Color.fromARGB(255, 64, 64, 64),
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
                                  color: Color.fromARGB(255, 63, 0, 209),
                                  onPressed: () {
                                    usercontroller.deleteUser(users[index].id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Color.fromARGB(255, 63, 0, 209),
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _description,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _address,
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
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
                        onChanged: (value) => {value.isNotEmpty}),
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 63, 0, 209)), // Set the text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _updateUser(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 63, 0, 209),
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
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
                        onChanged: (value) => {value.isNotEmpty}),
                    const SizedBox(height: 16.0),
                    TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
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
                        onChanged: (value) => {value.isNotEmpty}),
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 63, 0, 209)), // Set the text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _createUser();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 63, 0, 209),
              ),
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

    usercontroller.updateUser(userId, name, description, address, phone, email);

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

    usercontroller.createUser(name, description, address, phone, email);

    _nameController.clear();
    _descriptionController.clear();
    _addressController.clear();
    _emailController.clear();
    _phoneController.clear();
  }
}
