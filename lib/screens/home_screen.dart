import 'package:flutter/material.dart';
import 'package:rashify_app/screens/recipe_details_screen.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import 'recipe_details_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = apiService.fetchRecipes();
  }

  void _refreshData() {
    setState(() {
      futureRecipes = apiService.fetchRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rashify 👩‍🍳", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _refreshData)],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("لا يوجد وصفات حالياً"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final recipe = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(Icons.fastfood, color: Colors.orange, size: 30),
                  title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(recipe.category),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: recipe))
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}