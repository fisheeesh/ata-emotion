import 'dart:async';
import 'dart:io';
import 'package:emotion_check_in_app/screens/auth/login_screen.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final _storage = const FlutterSecureStorage();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  String? _userEmail;
  String? get userEmail => _userEmail;

  String? _userName;
  String? get userName => _userName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Login with Google and authorize with the backend
  Future<void> loginAndAuthorize(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final user = await _googleSignIn.signIn();
      _user = user;

      if (_user == null) {
        debugPrint("Google Sign-In was canceled by the user.");
        return;
      }

      /// Save the user's name after a successful login
      _userName = _user!.displayName;
      notifyListeners();

      /// Store the user's name securely for future use
      await _storage.write(key: 'user_name', value: _userName);

      final auth = await _user!.authentication;
      final accessToken = auth.accessToken;

      if (accessToken == null) {
        debugPrint("Access token not available.");
        return;
      }

      final isAuthorized = await _sendAccessTokenToServer(accessToken, context);

      if (isAuthorized) {
        EHelperFunctions.navigateToScreen(context, HomeScreen());
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends access token to the backend server
  /// Sends access token to the backend server with a timeout
  Future<bool> _sendAccessTokenToServer(String accessToken, BuildContext context) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Token': 'Bearer $accessToken',
      };

      debugPrint("Requesting to URL: ${ETexts.AUTHORIZATION_ENDPOINT}");
      debugPrint("Request Headers: $headers");

      // Allow self-signed certificates during development
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      /// Set a timeout for the HTTP request
      /// Timeout set to 10 seconds
      // final res = await http.post(Uri.parse(ETexts.AUTHORIZATION_ENDPOINT),
      //   headers: headers,).timeout(const Duration(seconds: 30));
      final response = await ioClient
          .post(
        Uri.parse(ETexts.AUTHORIZATION_ENDPOINT),
        headers: headers,
      )
          .timeout(const Duration(seconds: 30));

      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        final refreshToken = response.headers['refresh'];

        if (authToken != null && refreshToken != null) {
          await saveTokens(authToken, refreshToken);

          // Decode and store the email
          _decodeEmailFromToken(authToken);
          debugPrint("Tokens saved successfully.");
        }

        return true;
      } else {
        debugPrint("Authorization Failed: ${response.body}");
        return false;
      }
    } on TimeoutException {
      debugPrint("Request Timeout: The server took too long to respond.");
      EHelperFunctions.showSnackBar(
        context,
        "Request timed out. Please try again later.",
      );
      return false;
    } catch (e) {
      debugPrint("Error sending access token to server: $e");
      return false;
    }
  }

  /// Decode email from the token and store it
  void _decodeEmailFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      _userEmail = decodedToken['sub'];
      notifyListeners();
    } catch (e) {
      debugPrint("Error decoding token: $e");
    }
  }

  /// Logs out the user and clears tokens
  Future<void> logout(BuildContext context) async {
    try {
      await _googleSignIn.disconnect();
      _user = null;
      _userEmail = null;
      await clearTokens();
      notifyListeners();
      EHelperFunctions.navigateToScreen(context, LoginScreen());
      EHelperFunctions.showSnackBar(context, 'Logout Successfully.');
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
  /// Restore user name from Secure Storage
  Future<void> restoreUserName() async {
    _userName = await _storage.read(key: 'user_name');
    notifyListeners();
  }

  /// Save tokens securely in FlutterSecureStorage
  Future<void> saveTokens(String authToken, String refreshToken) async {
    await _storage.write(key: 'auth_token', value: authToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  /// Clears all tokens from storage
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// Restore email from stored token
  Future<void> restoreUserEmail() async {
    final authToken = await _storage.read(key: 'auth_token');
    if (authToken != null && isTokenValid(authToken)) {
      _decodeEmailFromToken(authToken);
    }
  }

  /// To check if the token is valid or expired
  bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;
    try {
      final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;
      return !JwtDecoder.isExpired(cleanToken);
    } catch (e) {
      debugPrint("Invalid token: $e");
      return false;
    }
  }
}