import 'dart:convert';
import 'dart:io';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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

      // Allow self-signed certificates during development
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      IOClient ioClient = IOClient(httpClient);

      final response = await ioClient.post(
        Uri.parse(ETexts.BASE_URL),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        final refreshToken = response.headers['refresh'];

        debugPrint("Authorization Token: $authToken");
        debugPrint("Refresh Token: $refreshToken");

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

  /// Logs out the user
  Future<void> logout() async {
    try {
      await _googleSignIn.disconnect();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}