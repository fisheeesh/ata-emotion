import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/provider/emotion_check_in_provider.dart';
import 'package:emotion_check_in_app/screens/auth/login_screen.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/screens/onBoard/on_boarding_screen.dart';
import 'package:emotion_check_in_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Server as global variable, so they can be access anywhere in this file.
int? isViewed;
String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');

  final storage = const FlutterSecureStorage();
  final authProvider = AuthProvider();

  /// Fetch the refresh token and restore the user's name
  token = await storage.read(key: 'refresh_token');
  if (token != null && authProvider.isTokenValid(token)) {
    await authProvider.restoreUserName();
    debugPrint('Token is not expired yet 😉.');
  }
  else{
    debugPrint('Token is already Expired. Please Logged in again.');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => EmotionCheckInProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATA - Emotion Check-in Application',
      theme: EAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return isViewed != 0
              ? const OnBoardingScreen()
              : authProvider.isTokenValid(token)
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}