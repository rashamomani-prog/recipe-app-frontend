import 'package:flutter/material.dart';

import '../../../auth/presentation/pages/login_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        title: const Text(
          "Menu Categories",
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(25.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildListDelegate([
                _buildProfessionalCard("Breakfast", Icons.coffee_outlined, const Color(0xFFFFFBEE)),
                _buildProfessionalCard("Lunch", Icons.restaurant_outlined, const Color(0xFFFFEFFE)),
                _buildProfessionalCard("Dinner", Icons.nightlight_outlined, const Color(0xFFF0F9FF)),
                _buildProfessionalCard("Desserts", Icons.cake_outlined, const Color(0xFFF2FCE2)),
                _buildProfessionalCard("Drinks", Icons.local_drink_outlined, const Color(0xFFFFF3E0)),
                _buildProfessionalCard("Healthy", Icons.spa_outlined, const Color(0xFFE0F2F1)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProfessionalCard(String title, IconData icon, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.orange.shade300,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4A4A),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}