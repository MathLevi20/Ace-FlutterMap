// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/database/auth.dart';
import 'package:maps/view/MapView.dart';
import 'package:maps/view/MenuView.dart';
import 'package:maps/view/PasswordResertView.dart';
import 'package:maps/view/RegisterView.dart';

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
        body: Container(
      margin: EdgeInsets.fromLTRB(16.0, 60, 16.0, 0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 70.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(75, 10, 75, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(100), // Image radius
                    child: Image.asset('assets/images/Logo-Isaf.png',
                        fit: BoxFit.cover),
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
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 63, 0, 209),
                ),
                child: const Text('Esqueceu a senha?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterUser()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 63, 0, 209),
                ),
                child: const Text('Criar Conta'),
              ),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Entrar'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 63, 0, 209),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
