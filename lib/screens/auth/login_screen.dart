import 'package:emotion_check_in_app/components/buttons/custom_button.dart';
import 'package:emotion_check_in_app/components/formFields/custom_text_form_field.dart';
import 'package:emotion_check_in_app/components/buttons/custom_outlined_button.dart';
import 'package:emotion_check_in_app/provider/auth_provider.dart';
import 'package:emotion_check_in_app/utils/constants/colors.dart';
import 'package:emotion_check_in_app/utils/constants/image_strings.dart';
import 'package:emotion_check_in_app/utils/constants/text_strings.dart';
import 'package:emotion_check_in_app/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:emotion_check_in_app/utils/theme/text_theme.dart';
import 'package:emotion_check_in_app/utils/constants/sizes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initSharePref();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void initSharePref() async {
    prefs = await SharedPreferences.getInstance();
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

  @override
  Widget build(BuildContext context) {
    final isGoogleLoading = context.watch<AuthProvider>().isLoading;

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

                /// Form
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// ATA Logo
                        _logoSection(),
                        const SizedBox(height: 70),

                        /// Form Title
                        _formTitleSection(),
                        const SizedBox(height: 15),

                        /// Email Field
                        CustomTextFormField(
                          controller: _emailController,
                          labelText: ETexts.EMAIL,
                          keyboardType: TextInputType.emailAddress,
                          validator: EValidator.validateEmail,
                        ),
                        const SizedBox(height: 20),

                        /// Password Field with Visibility Toggle
                        CustomTextFormField(
                          controller: _passwordController,
                          labelText: ETexts.PASSWORD,
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

                        /// Forgot Password
                        _forgotPasswordSection(),
                        const SizedBox(height: 10),

                        /// Login Button
                        _loginButton(),
                        const SizedBox(height: 20),

                        /// Google Login Button
                        _googleLoginButton(isGoogleLoading, context),
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

  CustomOutlinedButton _googleLoginButton(
      bool isGoogleLoading, BuildContext context) {
    return CustomOutlinedButton(
      width: double.infinity,
      height: 55,
      borderColor: EColors.primary,
      onPressed: isGoogleLoading
          ? null
          : () async {
              await context.read<AuthProvider>().loginAndAuthorize(context);
            },
      child: isGoogleLoading
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
                  ETexts.GOOGLE,
                  style: ETextTheme.lightTextTheme.titleMedium,
                ),
              ],
            ),
    );
  }

  CustomButton _loginButton() {
    return CustomButton(
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
                  ETexts.PROCESSING,
                  style: ETextTheme.lightTextTheme.titleLarge,
                ),
              ],
            )
          : Text(
              ETexts.LOGIN,
              style: ETextTheme.lightTextTheme.titleLarge,
            ),
    );
  }

  Align _forgotPasswordSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password logic
        },
        child: const Text(
          ETexts.FORGOTPW,
          style: TextStyle(color: EColors.grey),
        ),
      ),
    );
  }

  Text _formTitleSection() {
    return Text(
      ETexts.LOGINPAGETITLE,
      textAlign: TextAlign.start,
      style: ETextTheme.lightTextTheme.titleMedium,
    );
  }

  Image _logoSection() {
    return Image.asset(
      EImages.ataLogo,
      height: ESizes.hNormal,
    );
  }
}
