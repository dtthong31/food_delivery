// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthController {
  late firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // Add this method for testing purposes
  void setFirebaseAuth(firebase_auth.FirebaseAuth auth) {
    _auth = auth;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebase(userCredential.user);

      if (user != null) {
        saveUserFirebase(userCredential);
      }
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> _userRole(userUid) async {
    final docSnap = await db.collection("users").doc(userUid).get();
    final user = docSnap.data();
    print("Get user ${user}");
    return user?['role'] ?? false;
  }

  Future<void> saveUserFirebase(userCredential) async {
    final docSnap =
        await db.collection("users").doc(userCredential.user?.uid).get();
    final user = docSnap.data();
    if (user == null) {
      db.collection("users").doc(userCredential.user?.uid).set({
        'fullName': userCredential.user?.email,
        'email': userCredential.user?.email,
        'role': false
      }).onError((e, _) => print("Error writing document: $e"));
    }

    await _saveTokenAndUid(await userCredential.user?.getIdToken() ?? '',
        userCredential.user?.uid);
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final firebase_auth.AuthCredential credential =
            firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final firebase_auth.UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final user = _userFromFirebase(authResult.user);
        if (user != null) {
          saveUserFirebase(authResult);
        }
        return user;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _clearToken();
    print("Sign out!!!");
  }

  Future<bool> getRole(uid) async {
    final docSnap = await db.collection("users").doc(uid).get();
    final user = docSnap.data();
    return user?['role'] ?? false;
  }

  Future<void> _saveTokenAndUid(String token, String uid) async {
    var role = await getRole(uid);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('uid', uid);
    await prefs.setBool('role', role);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('uid');
    await prefs.remove('role');
  }

  User? _userFromFirebase(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
    );
  }
}
