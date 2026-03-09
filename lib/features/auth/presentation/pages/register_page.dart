import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Join Rashify ✨",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create an account to start your delicious journey with us.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 40),
                _buildCasualField(
                  "Full Name",
                  Icons.person_outline_rounded,
                  const Color(0xFFFFEFFE),
                ),

                const SizedBox(height: 20),
                _buildCasualField(
                  "Email Address",
                  Icons.alternate_email_rounded,
                  const Color(0xFFFFFBEE),
                ),

                const SizedBox(height: 20),

                _buildCasualField(
                  "Password",
                  Icons.lock_open_rounded,
                  const Color(0xFFF0F9FF),
                  isPassword: true,
                ),

                const SizedBox(height: 40),

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
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Create Account",
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
                    onPressed: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                        children: [
                          const TextSpan(text: "Already a member? "),
                          TextSpan(
                            text: "Log in here",
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
                const SizedBox(height: 30),
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