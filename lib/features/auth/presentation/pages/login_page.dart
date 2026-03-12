import 'package:flutter/material.dart';
import '../../../recipes/presentation/pages/categories_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Welcome to Rashify ",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We missed your cooking! Let's get you signed in.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 50),
                _buildCasualField(
                  "Email Address",
                  Icons.alternate_email_rounded,
                  const Color(0xFFFFFBEE),
                ),

                const SizedBox(height: 20),

                _buildCasualField(
                  "Password",
                  Icons.lock_open_rounded,
                  const Color(0xFFFFEFFE),
                  isPassword: true,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CategoriesPage()),
                      );
                    },
                    child: const Text(
                      "Let's get started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage())
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                        children: [
                          const TextSpan(text: "New here? "),
                          TextSpan(
                            text: "Create an account",
                            style: TextStyle(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.bold
                            ),
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
    );
  }
  Widget _buildCasualField(String hint, IconData icon, Color bgColor, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        obscureText: isPassword,
        textAlign: TextAlign.left,
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