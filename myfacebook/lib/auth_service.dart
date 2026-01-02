import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '7613530807-6fhvredfglgomj1lpjd98iromjoosfvc.apps.googleusercontent.com',
  );  

  // ======================
  // EMAIL & PASSWORD SIGN UP
  // ======================
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Signup failed';
    }
  }

  // ======================
  // EMAIL & PASSWORD LOGIN
  // ======================
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  // ======================
  // GOOGLE SIGN-IN
  // ======================
  Future<User?> signInWithGoogle() async {
  try {
    GoogleAuthProvider provider = GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithPopup(provider);

    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    // VERY IMPORTANT: rethrow meaningful error
    throw e;
  }
}


  // ======================
  // SIGN OUT
  // ======================
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
