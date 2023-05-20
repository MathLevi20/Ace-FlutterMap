// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maps/view/MapView.dart';

import '../database/database.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _cadastrar() async {
    String password = _senhaController.text;
    String email = _emailController.text;
    //User novoContato = User(
    //id: DateTime.now().microsecondsSinceEpoch,
    //email: email,
    // senha: senha,
    //);

    //await insertContato(novoContato);
    await loginUser(email, password);
    var isLoggedIn = await loginUser(email, password);
    print(isLoggedIn);
    if (isLoggedIn != null && isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoogleMaps()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erro!'),
          content: const Text('Seu Cadastro não existe'),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
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
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                onChanged: (value) => {value.isNotEmpty},
              ),
              const SizedBox(height: 1.0),
              TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  onChanged: (value) => {value.isNotEmpty}),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
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
