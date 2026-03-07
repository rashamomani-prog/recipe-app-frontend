import 'package:flutter/material.dart';
import 'recipe_list_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'أكل صحي', 'icon': Icons.favorite_rounded, 'color': Colors.green},
    {'name': 'سلطات', 'icon': Icons.flatware_rounded, 'color': Colors.lightGreen},
    {'name': 'وجبات رئيسية', 'icon': Icons.restaurant_rounded, 'color': Colors.orange},
    {'name': 'عصائر', 'icon': Icons.local_drink_rounded, 'color': Colors.blue},
    {'name': 'مقبلات', 'icon': Icons.fastfood_rounded, 'color': Colors.amber},
    {'name': 'حلويات', 'icon': Icons.cake_rounded, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("قائمة التصنيفات", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeListPage(
                    categoryName: cat['name'],
                    themeColor: cat['color'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: cat['color'].withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: cat['color'].withOpacity(0.2),
                    child: Icon(cat['icon'], size: 30, color: cat['color']),
                  ),
                  const SizedBox(height: 12),
                  Text(cat['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}