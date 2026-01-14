import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Using the clientId from your working code
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '7613530807-6fhvredfglgomj1lpjd98iromjoosfvc.apps.googleusercontent.com',
  );

  // ======================
  // EMAIL & PASSWORD SIGN UP
  // ======================
  Future<UserModel?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String location,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(name);

      return UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        location: location,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  // ======================
  // EMAIL & PASSWORD LOGIN
  // ======================
  Future<UserModel?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? user.email!.split('@')[0],
          email: user.email!,
          location: '', // We'll get this from Firestore later
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  // ======================
  // GOOGLE SIGN-IN (Web optimized)
  // ======================
  Future<UserModel?> signInWithGoogle() async {
    try {
      // For web, we need to use signInWithPopup approach
      GoogleAuthProvider provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.addScope('profile');

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(provider);

      final user = userCredential.user;

      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? user.email!.split('@')[0],
          email: user.email!,
          location: '', // Default location for Google users
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Re-throw meaningful error
      throw _mapFirebaseError(e);
    } catch (e) {
      throw 'Google sign-in failed: $e';
    }
  }

  // Alternative Google Sign-In method (mobile-friendly)
  Future<UserModel?> signInWithGoogleAlt() async {
    try {
      // This works better for mobile
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google sign-in cancelled';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        return UserModel(
          id: user.uid,
          name: user.displayName ?? user.email!.split('@')[0],
          email: user.email!,
          location: '',
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    } catch (e) {
      throw 'Google sign-in failed: $e';
    }
  }

  // ======================
  // SIGN OUT
  // ======================
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ======================
  // GET CURRENT USER
  // ======================
  UserModel? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        name: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        location: '', // We'll need to store this separately
      );
    }
    return null;
  }

  // ======================
  // PASSWORD RESET
  // ======================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  // ======================
  // ERROR MAPPING
  // ======================
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'popup-closed-by-user':
        return 'Sign-in cancelled.';
      case 'account-exists-with-different-credential':
        return 'This email is already registered using another method.';
      case 'operation-not-allowed':
        return 'Google sign-in is not enabled.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }

  // Static methods for backward compatibility (used in your current screens)
  static Future<UserModel?> login(String email, String password) async {
    return await AuthService().signInWithEmail(
      email: email,
      password: password,
    );
  }

  static Future<UserModel?> register(
    String name,
    String email,
    String password,
    String location,
  ) async {
    return await AuthService().signUpWithEmail(
      name: name,
      email: email,
      password: password,
      location: location,
    );
  }
}
