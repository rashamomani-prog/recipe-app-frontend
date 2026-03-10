import 'package:flutter/material.dart';
import 'categories_page.dart';
import 'recipe_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: const Text(
            "Rashify 🥗",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back,",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Text(
                "What to cook today? 👨‍🍳",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFAB40), Color(0xFFFF9100)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Featured Recipe", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 5),
                    Text("Healthy Quinoa Salad",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Explore Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                    },
                    child: const Text("View All", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  )
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildQuickCategory(context, Icons.spa_outlined, "Healthy", const Color(0xFFE2F3E9), Colors.green),
                    _buildQuickCategory(context, Icons.cake_outlined, "Desserts", const Color(0xFFFCE4EC), Colors.pink),
                    _buildQuickCategory(context, Icons.coffee_outlined, "Breakfast", const Color(0xFFFFF3E0), Colors.orange),
                    _buildQuickCategory(context, Icons.local_drink_outlined, "Drinks", const Color(0xFFE1F5FE), Colors.blue),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // يمكنك إضافة قسم "وصفات مقترحة" هنا لاحقاً
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildQuickCategory(BuildContext context, IconData icon, String label, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeListPage(
                categoryName: label,
                themeColor: iconColor,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 13
              ),
            ),
          ],
        ),
      ),
    );
  }
}