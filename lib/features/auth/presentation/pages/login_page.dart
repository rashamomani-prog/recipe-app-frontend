import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../recipes/presentation/pages/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final Function(bool)? onThemeChanged;

  const LoginPage({super.key, this.onThemeChanged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isDarkMode = false;

  void _loginUser() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }
    context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          bool exit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Exit App"),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Exit")),
              ],
            ),
          );
          return exit;
        },
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F6),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.restaurant_menu, color: Colors.orange, size: 30),
                        IconButton(
                          icon: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            if (widget.onThemeChanged != null) {
                              widget.onThemeChanged!(!isDark);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Welcome to Rashify",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF333333)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We missed your cooking! Let's get you signed in.",
                      style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.4),
                    ),
                    const SizedBox(height: 50),
                    _buildCasualField(
                        "Email Address", Icons.alternate_email_rounded,
                        isDark ? Colors.grey.shade900 : const Color(0xFFFFFBEE),
                        controller: emailController, isDark: isDark),
                    const SizedBox(height: 20),
                    _buildCasualField("Password", Icons.lock_open_rounded,
                        isDark ? Colors.grey.shade900 : const Color(0xFFFFEFFE),
                        controller: passwordController, isPassword: true, isDark: isDark),
                    const SizedBox(height: 30),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (a, b) => a is AuthLoading || b is AuthLoading,
                      builder: (context, state) {
                        final loading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade400,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 0,
                            ),
                            onPressed: loading ? null : _loginUser,
                            child: loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    "Let's get started",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),
                            children: [
                              const TextSpan(text: "New here? "),
                              TextSpan(
                                text: "Create an account",
                                style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCasualField(String hint, IconData icon, Color bgColor,
      {bool isPassword = false, TextEditingController? controller, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.left,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange.shade300, size: 22),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
