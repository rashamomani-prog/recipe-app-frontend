import '../../domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.accentColor,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'].toString(),
      title: map['title'],
      icon: Icons.fastfood_outlined,
      accentColor: Colors.orange.shade50,
    );
  }
}