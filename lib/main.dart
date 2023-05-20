import 'package:flutter/material.dart';
import 'package:maps/view/Login.dart';
import 'package:maps/view/MapView.dart';
import 'package:uuid/uuid.dart';

import 'database/database.dart';
import 'model/Pessoa.dart';
import 'view/Register.dart';

void main() async {
  runApp(const RegisterApp());

  await createConnection();
  await getUserMySql();
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(), // alterado de CadastroPage para ContatosPage
    );
  }
}

var uuid = const Uuid();


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/user.png',
                width: 100,
                height: 150,
              ),
              const SizedBox(height: 24.0),
                            ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Registro'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Mapa'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GoogleMaps()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

insertContato(User novoContato) {}

class HomePage extends StatefulWidget {
  const HomePage({super.key, 
    required this.email,
    required this.senha,
  });

  final String? email;
  final String? senha;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Email: ${widget.email}!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Sua senha é:${widget.senha}!',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueGrey[900],
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
