import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginView.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'NeonTubes2',
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 63, 0, 209),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 171, 4, 255),
              Color.fromARGB(255, 138, 0, 209),
              Color.fromARGB(255, 63, 0, 209),
            ],
          ),
        ),
        child: Center(
          child: Card(
            color: Color.fromARGB(255, 255, 255, 255),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user?.photoURL ??
                          'https://firebasestorage.googleapis.com/v0/b/pointer-flutter.appspot.com/o/user.png?alt=media&token=4d995d18-251d-4d18-9971-8b8346372aeb'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'User: ${user?.displayName ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NeonTubes2',
                        color: Color.fromARGB(255, 64, 64, 64),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${user?.email ?? ''}',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'NeonTubes2',
                        color: const Color.fromARGB(255, 64, 64, 64),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 171, 4, 255),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        shadowColor: Colors.pinkAccent.withOpacity(0.8),
                        elevation: 4,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'NeonTubes2',
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
