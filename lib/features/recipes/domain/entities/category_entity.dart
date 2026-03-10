import 'package:flutter/material.dart';

class CategoryEntity {
  final String id;
  final String title;
  final IconData icon;
  final Color accentColor;

  CategoryEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
  });
}