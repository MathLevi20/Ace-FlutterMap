import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/view/Login.dart';
import 'package:maps/view/MapView.dart';

import '../database/auth.dart';
import 'ListUser.dart';

class Menu extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Container(
            margin: EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
            child: Center(
                child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/IFPI.png', // Substitua pelo caminho da sua imagem
                  width: 200, // Largura desejada da imagem
                  height: 200, // Altura desejada da imagem
                ),
              ),
              GridView.count(
                crossAxisCount: 2, // número de colunas na grade
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ListUser()));
                        },
                        child: const Text('Contact',
                            style: TextStyle(fontSize: 18.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GoogleMaps()),
                        );
                      },
                      child:
                          const Text('Map', style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ListUser()));
                        },
                        child: const Text('Profile',
                            style: TextStyle(fontSize: 18.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _auth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text('Logout',
                            style: TextStyle(fontSize: 18.0))),
                  ),
                ],
              ),
            ]))));
  }
}
