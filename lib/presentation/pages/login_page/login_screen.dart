import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrigo_v3/core/constants/app_strings.dart';
import 'package:agrigo_v3/presentation/widgets/custom_text_field.dart';
import 'package:agrigo_v3/presentation/widgets/custom_button.dart';
import 'package:agrigo_v3/presentation/pages/login_page/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccess) {
                  // حفظ التوكن باستخدام SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('token', state.token); // حفظ التوكن

                  // طباعة التوكن في الكونسل
                  print("Token saved: ${state.token}");

                  // عرض رسالة النجاح
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Login successful!"),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // الانتقال إلى الصفحة الرئيسية
                  Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
                }
                if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return _buildLoginForm(context, state);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: -MediaQuery.of(context).size.width / 2,
          right: -MediaQuery.of(context).size.width / 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(200),
              bottomRight: Radius.circular(200),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/login.jpg',
                  width: MediaQuery.of(context).size.width * 2,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      AppStrings.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 250),
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Container(
                child: Image.asset('assets/images/Logo.png', width: 100, height: 100),
              ),
            ),
            const Text(
              AppStrings.welcomeBack,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(AppStrings.loginToYourAccount),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomTextField(controller: _usernameController, label: AppStrings.username),
          const SizedBox(height: 10),
          CustomTextField(controller: _passwordController, label: AppStrings.password, isPassword: true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(AppStrings.forgotPassword),
            ),
          ),
          const SizedBox(height: 50),
          if (state is LoginLoading)
            const CircularProgressIndicator()
          else
            CustomButton(
              text: AppStrings.login,
              onPressed: () {
                if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                  context.read<LoginBloc>().add(
                        LoginSubmitted(
                          email: _usernameController.text,
                          password: _passwordController.text,
                        ),
                      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill in all fields"),
                      backgroundColor: Colors.teal,
                    ),
                  );
                }
              },
            ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(AppStrings.signup),
          ),
        ],
      ),
    );
  }
}