import 'package:flutter/material.dart';
import 'categories_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Rashify 🥗", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              // هون ممكن نحط صفحة البروفايل لاحقاً
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نص ترحيبي
              const Text(
                "أهلاً بكِ في مطبخك،",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Text(
                "ماذا نطبخ اليوم؟ 👨‍🍳",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("وصفة اليوم المميزة", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 5),
                    Text("سلطة الكينوا الصحية", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("اكتشفي الأقسام", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage()));
                    },
                    child: const Text("عرض الكل"),
                  )
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildQuickCategory(Icons.apple, "صحي", Colors.green, context),
                    _buildQuickCategory(Icons.cake, "حلويات", Colors.pink, context),
                    _buildQuickCategory(Icons.local_drink, "عصائر", Colors.blue, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildQuickCategory(IconData icon, String label, Color color, BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}