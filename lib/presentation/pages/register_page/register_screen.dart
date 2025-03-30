import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_bloc.dart';
import 'package:agrigo_v3/core/constants/app_strings.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // التخلص من TextEditingController عند انتهاء الشاشة
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // حقل الاسم
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل البريد الإلكتروني
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      hintText: "Enter E-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // حقل كلمة المرور
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(Icons.visibility_off),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Checkbox مع الشروط والأحكام
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      const Expanded(
                        child: Text(
                          "By signing up you agree to our terms & conditions of use and privacy policy.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // زر Sign Up
                  BlocConsumer<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration successful!"),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, '/login');
                        });
                      } else if (state is RegisterFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RegisterLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          if (name.isEmpty || email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in all fields"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          context.read<RegisterBloc>().add(
                                RegisterSubmitted(
                                  name: name,
                                  email: email,
                                  password: password,
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // رابط تسجيل الدخول
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: -MediaQuery.of(context).size.width / 2,
          right: -MediaQuery.of(context).size.width / 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(150),
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/login.jpg', // استبدلها بالصورة المناسبة
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
                      // استبدلها باسم التطبيق الخاص بك
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
          ],
        ),
      ],
    );
  }
}