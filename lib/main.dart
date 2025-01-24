import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/screens/auth/login_screen.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/screens/onBoard/on_boarding_screen.dart';
import 'package:emotion_check_in_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');

  final storage = const FlutterSecureStorage();

  /// Fetch the token from Secure Storage
  token = await storage.read(key: 'refresh_token');
  /// Log the saved token for debugging
  debugPrint("Saved Token: $token");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          title: 'ATA - Emotion Check-in Application',
          theme: EAppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: isViewed != 0
              ? const OnBoardingScreen()
              : authProvider.isTokenValid(token)
              ? HomeScreen()
              : const LoginScreen(),
        );
      },
    );
  }
}