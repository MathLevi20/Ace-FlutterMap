import 'package:firebase_auth/firebase_auth.dart';

String? getUserUID() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final uid = user.uid;
    return uid;
  }
  return null;
}
