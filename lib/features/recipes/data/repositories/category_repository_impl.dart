import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<List<CategoryEntity>> getCategories() async {
    return [
      CategoryEntity(
        id: '1',
        title: 'Breakfast',
        icon: Icons.coffee_outlined,
        accentColor: const Color(0xFFFFFBEE),
      ),
      CategoryEntity(
        id: '2',
        title: 'Lunch',
        icon: Icons.restaurant_outlined,
        accentColor: const Color(0xFFFFEFFE),
      ),
      CategoryEntity(
        id: '3',
        title: 'Dinner',
        icon: Icons.nightlight_outlined,
        accentColor: const Color(0xFFF0F9FF),
      ),
      CategoryEntity(
        id: '4',
        title: 'Desserts',
        icon: Icons.cake_outlined,
        accentColor: const Color(0xFFF2FCE2),
      ),
      CategoryEntity(
        id: '5',
        title: 'Drinks',
        icon: Icons.local_drink_outlined,
        accentColor: const Color(0xFFFFF3E0),
      ),
      CategoryEntity(
        id: '6',
        title: 'Healthy',
        icon: Icons.spa_outlined,
        accentColor: const Color(0xFFE0F2F1),
      ),
    ];
  }
}