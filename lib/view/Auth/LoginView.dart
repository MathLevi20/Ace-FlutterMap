// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:maps/controller/AuthController.dart';
import 'package:maps/view/Auth/PasswordResertView.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> _signIn() async {
    String password = _senhaController.text;
    String email = _emailController.text;
    AuthService authService = AuthService();

    String loginResult =
        await authService.signInWithEmailAndPassword(email, password);
    print(loginResult);
    if (loginResult.startsWith('Erro')) {
      final errorMessage = loginResult
          .toString()
          .replaceAll('Erro: [firebase_auth/unknown] ', '');

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erro'),
          content: Text(errorMessage),
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
    } else {

      Navigator.pushNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 70.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(75, 10, 75, 0),
                child: SizedBox.fromSize(
                  size: Size.fromRadius(100), // Image radius
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 63, 0, 209), width: 1.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 86, 86, 86), width: 0.0),
                  ),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
                ),
                onChanged: (value) => {value.isNotEmpty},
              ),
              const SizedBox(height: 10.0),
              TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 63, 0, 209), width: 1.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 86, 86, 86), width: 0.0),
                    ),
                    border: OutlineInputBorder(),
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
                  ),
                  onChanged: (value) => {value.isNotEmpty}),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PasswordResetScreen()),
                  );
                  Navigator.pushNamed(context, '/passwordresert');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 63, 0, 209),
                ),
                child: const Text('Esqueceu a senha?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 63, 0, 209),
                ),
                child: const Text('Criar Conta'),
              ),
              ElevatedButton(
                onPressed: _signIn,
                child: const Text('Entrar'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 63, 0, 209),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ));
  }
}
