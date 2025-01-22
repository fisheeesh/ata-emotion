import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/screens/auth/login_screen.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/screens/onBoard/on_boarding_screen.dart';
import 'package:emotion_check_in_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');

  // Fetch the token from SharedPreferences
  final token = prefs.getString('token');
  debugPrint("Saved Token: $token"); // Log the saved token for debugging

  runApp(App(token: token));
}

class App extends StatelessWidget {
  final String? token;

  const App({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    // Validate token
    bool isTokenValid(String? token) {
      if (token == null || token.isEmpty) return false;
      try {
        // Remove "Bearer " prefix if it exists
        final cleanToken = token.startsWith('Bearer ') ? token.substring(7) : token;

        // Decode and check expiration
        return !JwtDecoder.isExpired(cleanToken);
      } catch (e) {
        debugPrint("Invalid token: $e");
        return false;
      }
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'ATA - Emotion Check-in Application',
        theme: EAppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: isViewed != 0
            ? const OnBoardingScreen()
            : isTokenValid(token)
            ? const HomeScreen()
            : const LoginScreen(),
      ),
    );
  }
}