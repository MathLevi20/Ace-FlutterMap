import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps/view/Auth/LoginView.dart';
import 'package:maps/view/Auth/PasswordResertView.dart';
import 'package:maps/view/Auth/RegisterView.dart';
import 'package:maps/view/Contacts/ContactsListView.dart';
import 'package:maps/view/Map/MapView.dart';
import 'package:maps/view/User/UserMenuView.dart';
import 'package:maps/view/User/UserProfileView.dart';

import 'firebase_options.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    routes: {
      '/login': (context) => LoginScreen(),
      '/menu': (context) => MenuScreen(),
      '/register': (context) => RegisterScreen(),
      '/passwordresert': (context) => PasswordResetScreen(),
      '/map': (context) => MapScreen(),
      '/contacts': (context) => ListContactsScreen(),
      '/profile': (context) => ProfileScreen(),
    },
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
