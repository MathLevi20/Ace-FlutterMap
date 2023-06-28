import 'package:flutter/material.dart';
import '../../controller/AuthController.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ACE'),
          backgroundColor: Color.fromARGB(255, 63, 0, 209),
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: ListView(children: [
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(75, 10, 75, 0),
              child: SizedBox.fromSize(
                size: Size.fromRadius(100), // Image radius
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Card(
                  elevation: 1,
                  child: GestureDetector(
                    onTap: () {
                                Navigator.pushNamed(context, '/contacts');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.manage_accounts_sharp,
                            color: Color.fromARGB(255, 63, 0, 209),
                            size: 50.0,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Controle de usuários',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Gerencie usuários e acesse perfis',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: new InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/map');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.map_sharp,
                            color: Color.fromARGB(255, 63, 0, 209),
                            size: 50.0,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mapa',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Veja a localização dos usuários',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: GestureDetector(
                    onTap: () {
      
                                            Navigator.pushNamed(context, '/profile');

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_box_rounded,
                            color: Color.fromARGB(255, 63, 0, 209),
                            size: 50.0,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Perfil',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Seus confira seus dados',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  child: new InkWell(
                    onTap: () {
                      authController.logoutUser();

                      Navigator.pushNamed(context, '/login');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: Color.fromARGB(255, 63, 0, 209),
                            size: 50.0,
                            semanticLabel:
                                'Text to announce in accessibility modes',
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sair',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ])),
        )));
  }
}
