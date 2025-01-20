import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logOut() => _googleSignIn.disconnect();
}