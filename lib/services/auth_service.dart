import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final logger = Logger();

  //Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in with email and password
  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on FirebaseException catch (e) {
      logger.e('Failed to sign in with email and password: $e');
    }
  }
  //Register with email and password
Future signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredential.user;
    } on FirebaseException catch (e) {
      logger.e('Failed to sign up with email and password: $e');
    }
  }
  //Sign out
Future signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseException catch (e) {
      logger.e('Failed to sign out: $e');
    }
  }
}
