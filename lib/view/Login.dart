// ignore_for_file: use_build_context_synchronously


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/database/auth.dart';
import 'package:maps/view/MapView.dart';
import 'package:maps/view/Menu.dart';
import 'package:maps/view/PasswordResert.dart';

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
    AuthService authService = AuthService();

    String loginResult =
        await authService.signInWithEmailAndPassword(email, password);
    if (loginResult.startsWith('Erro')) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Erro!'),
          content: Text(loginResult),
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Menu()),
      );
    }
    //await insertContato(novoContato);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Envio de e-mail de recuperação de senha bem-sucedido
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text(
                'Um e-mail de recuperação de senha foi enviado para $email.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Tratamento de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text(
                'Não foi possível enviar o e-mail de recuperação de senha.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
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
        body: Container(
          margin: EdgeInsets.fromLTRB(16.0, 60, 16.0, 0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(
                    'assets/images/IFPI.png',
                    width: 100,
                    height: 150,
                  ),
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
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordResetScreen()),
                      );
                    },
                    child: const Text('Esqueceu a senha?'),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _cadastrar,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
