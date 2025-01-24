import 'dart:io';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/io_client.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final _storage = const FlutterSecureStorage();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  /// Login with Google and authorize with the backend
  Future<bool> loginAndAuthorize() async {
    try {
      final user = await _googleSignIn.signIn();
      _user = user;

      if (_user == null) {
        debugPrint("Google Sign-In was canceled by the user.");
        return false;
      }

      final auth = await _user!.authentication;
      final accessToken = auth.accessToken;

      if (accessToken == null) {
        debugPrint("Access token not available.");
        return false;
      }

      final isAuthorized = await _sendAccessTokenToServer(accessToken);
      return isAuthorized;
    } catch (e) {
      debugPrint("Google Login Error: $e");
      return false;
    }
  }

  /// Sends access token to the backend server
  Future<bool> _sendAccessTokenToServer(String accessToken) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Token': 'Bearer $accessToken',
      };

      debugPrint("Requesting to URL: ${ETexts.BASE_URL}");
      debugPrint("Request Headers: $headers");

      /// Allow self-signed certificates during development
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        Uri.parse(ETexts.BASE_URL),
        headers: headers,
      );

      debugPrint('Response: $response');

      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        final refreshToken = response.headers['refresh'];

        if (authToken != null && refreshToken != null) {
          await saveTokens(authToken, refreshToken);
          debugPrint("Tokens saved successfully.");
        }

        return true;
      } else {
        debugPrint("Authorization Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error sending access token to server: $e");
      return false;
    }
  }

  /// Logs out the user and clears tokens
  Future<void> logout() async {
    try {
      /// Clear Google sign-in session
      await _googleSignIn.disconnect();

      /// Set user to null when logged out
      _user = null;

      /// Clear tokens from secure storage
      await clearTokens();

      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

  /// Saves tokens securely in FlutterSecureStorage
  Future<void> saveTokens(String authToken, String refreshToken) async {
    await _storage.write(key: 'auth_token', value: authToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  /// Clears all tokens from storage
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// To check the refresh toke is valid or expired
  bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;
    try {
      /// Remove "Bearer " prefix if it exists
      final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;

      /// Decode and check expiration
      return !JwtDecoder.isExpired(cleanToken);
    } catch (e) {
      debugPrint("Invalid token: $e");
      return false;
    }
  }
}