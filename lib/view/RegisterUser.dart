import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:maps/main.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  PickedFile? pickedImage;
  File? imageFile;
  bool _load = false; // Initialize with null
  String _errorMessage = '';

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _registerUser() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Upload the user's photo to Firebase Storage
        if (imageFile != null) {
          final firebase_storage.Reference storageRef =
              firebase_storage.FirebaseStorage.instance.ref().child(
                    'users/${user.uid}/photo.jpg',
                  );
          final firebase_storage.UploadTask uploadTask =
              storageRef.putFile(imageFile!);
          await uploadTask.whenComplete(() async {
            final String downloadURL = await storageRef.getDownloadURL();
            await user.updatePhotoURL(downloadURL);
            await user.updateDisplayName(_usernameController.text);
          });
        } else {
          await user.updateDisplayName(_usernameController.text);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'A senha é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'O e-mail já está em uso.';
      } else {
        _errorMessage = 'Erro: ${e.message}';
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 60, 16.0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!) as ImageProvider<Object>
                    : AssetImage('assets/images/default_avatar.png'),
              ),
              TextButton(
                onPressed: _pickImage,
                child: Text('Escolher Foto'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 8.0),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
