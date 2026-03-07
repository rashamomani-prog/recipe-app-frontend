import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  final String categoryName;
  final Color themeColor;

  const RecipeListPage({
    super.key,
    required this.categoryName,
    required this.themeColor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 80, color: themeColor.withOpacity(0.3)),
            const SizedBox(height: 20),
            Text(
              "وصفات $categoryName قادمة قريباً!",
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Text("بانتظار إضافة المكونات والتحضير... 👨‍🍳"),
          ],
        ),
      ),
    );
  }
}