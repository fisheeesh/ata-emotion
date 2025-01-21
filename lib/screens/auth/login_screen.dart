import 'package:emotion_check_in_app/components/buttons/custom_button.dart';
import 'package:emotion_check_in_app/components/formFields/custom_text_form_field.dart';
import 'package:emotion_check_in_app/components/buttons/custom_outlined_button.dart';
import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/screens/main/home_screen.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/image_strings.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/helpers/helper_functions.dart';
import 'package:emotion_check_in_app/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        _formKey.currentState!.save();
        debugPrint('Success');
      } catch (e) {
        debugPrint("Login Error: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Perform login and authorization
      final isAuthorized = await authProvider.loginAndAuthorize();

      if (isAuthorized) {
        // Navigate to HomeScreen if authorized
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: authProvider.user),
          ),
        );
      } else {
        // Show error if authorization fails
        EHelperFunctions.showSnackBar(context, 'Authorization Failed.');
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");
      EHelperFunctions.showSnackBar(context, 'Google Sign-in Failed.');
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: ESizes.md),
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo section
                        Column(
                          children: [
                            Image.asset(
                              EImages.ataLogo,
                              height: ESizes.hNormal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 70),
                        Text(
                          ETexts.logInTitle,
                          textAlign: TextAlign.start,
                          style: ETextTheme.lightTextTheme.titleMedium,
                        ),
                        const SizedBox(height: 15),

                        // Custom Email Field
                        CustomTextFormField(
                          controller: _emailController,
                          labelText: ETexts.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: EValidator.validateEmail,
                        ),
                        const SizedBox(height: 20),

                        // Custom Password Field with Visibility Toggle
                        CustomTextFormField(
                          controller: _passwordController,
                          labelText: ETexts.password,
                          obscureText: !_isPasswordVisible,
                          validator: EValidator.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password logic
                            },
                            child: const Text(
                              ETexts.forgotPw,
                              style: TextStyle(color: EColors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        CustomButton(
                          width: ESizes.wFull,
                          height: ESizes.hNormal,
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: ESizes.wXs,
                                height: ESizes.hXs,
                                child: CircularProgressIndicator(
                                  color: EColors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ETexts.processing,
                                style:
                                ETextTheme.lightTextTheme.titleLarge,
                              ),
                            ],
                          )
                              : Text(
                            ETexts.logIn,
                            style: ETextTheme.lightTextTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Continue with Google (Using Custom Outlined Button)
                        CustomOutlinedButton(
                          width: double.infinity,
                          height: 55,
                          borderColor: EColors.primary,
                          onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                          child: _isGoogleLoading
                              ? const SizedBox(
                            width: ESizes.wXs,
                            height: ESizes.hXs,
                            child: CircularProgressIndicator(
                              color: EColors.primary,
                              strokeWidth: 2.0,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                EImages.googleLogo,
                                height: ESizes.hXs,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                ETexts.google,
                                style:
                                ETextTheme.lightTextTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}