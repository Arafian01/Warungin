import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      
      if (user != null) {
        return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailPassword(
    String email, 
    String password,
    String displayName,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        
        // Save user data to Firestore
        UserModel userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName,
          createdAt: DateTime.now(),
        );
        
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
        
        return userModel;
      }
      return null;
    } catch (e) {
      throw Exception('Registrasi gagal: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout gagal: ${e.toString()}');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data user: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Gagal mengirim email reset password: ${e.toString()}');
    }
  }
}
