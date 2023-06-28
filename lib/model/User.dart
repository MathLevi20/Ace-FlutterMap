import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? uid;
  final String? displayName;
  final String? email;
  final String? photoURL;

  UserModel({this.uid, this.displayName, this.email, this.photoURL});

  static Future<UserModel?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    await user.reload();
    user = FirebaseAuth.instance.currentUser;

    return UserModel(
      uid: user?.uid,
      displayName: user?.displayName,
      email: user?.email,
      photoURL: user?.photoURL,
    );
  }
}
