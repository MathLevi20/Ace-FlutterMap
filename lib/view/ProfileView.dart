import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Color(0xFF130063),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F0954),
              Color(0xFF2C0F6E),
            ],
          ),
        ),
        child: Center(
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
                'Username: ${user?.displayName ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NeonTubes2',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.pinkAccent.withOpacity(0.8),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Email: ${user?.email ?? ''}',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NeonTubes2',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.pinkAccent.withOpacity(0.8),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the login screen or any desired screen after logout
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFAE00FF),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadowColor: Colors.pinkAccent.withOpacity(0.8),
                  elevation: 4,
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NeonTubes2',
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
