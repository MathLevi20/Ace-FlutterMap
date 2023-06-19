import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
        backgroundColor: Color.fromARGB(255, 63, 0, 209),
        elevation: 0,
      ),
           body: Container(
      child: SingleChildScrollView( child:Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60.0),
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
              const SizedBox(height: 15.0),

             Center(child: Text(
                'Insira seu e-mail para recuperar a senha',
                style: TextStyle(fontSize: 16.0),
              ),), 
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 63, 0, 209), width: 1.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 86, 86, 86), width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendPasswordResetEmail(_email);
                  }
                },
                child: Text('Recuperar Senha'),
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
      ),
      ),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucesso'),
            content: Text(
                'Um e-mail de recuperação de senha foi enviado para $email'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 63, 0, 209),
                ),
              ),
            ],
          );
        },
      );
    } catch (error) {
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
}
