import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserData(credential.user);
      return credential;
    } catch (e) {
      throw e;
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserData(credential.user);
      return credential;
    } catch (e) {
      throw e;
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google sign in aborted';
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      await _saveUserData(userCredential.user);
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    try {
      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create an OAuthCredential from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);
      await _saveUserData(userCredential.user);
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      await _prefs.clear();
    } catch (e) {
      throw e;
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserData(User? user) async {
    if (user != null) {
      await _prefs.setString('user_id', user.uid);
      await _prefs.setString('user_email', user.email ?? '');
      await _prefs.setString('user_name', user.displayName ?? '');
      await _prefs.setString('user_photo', user.photoURL ?? '');
    }
  }

  // Get saved user data
  Map<String, String> getSavedUserData() {
    return {
      'user_id': _prefs.getString('user_id') ?? '',
      'user_email': _prefs.getString('user_email') ?? '',
      'user_name': _prefs.getString('user_name') ?? '',
      'user_photo': _prefs.getString('user_photo') ?? '',
    };
  }
} 