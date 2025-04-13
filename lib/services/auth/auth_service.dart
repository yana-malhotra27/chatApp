import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception("Sign-in failed: ${e.message}");
    }
  }

  // Sign in with username and password
  Future<UserCredential> signInWithUsernamePassword(
    String username,
    String password,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('Users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found');
      }

      final email = querySnapshot.docs.first['email'];
      return await signInWithEmailPassword(email, password);
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // Sign up with email, password, and username
  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save to Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username,
      });

      // Update display name in Firebase Auth
      await userCredential.user!.updateDisplayName(username);
      await userCredential.user!.reload();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
