import 'package:flutter/material.dart';

class TemplateMetadata {
  final String id;
  final String name;
  final String category;
  final Color primaryColor;
  final Color accentColor;
  final String description;

  const TemplateMetadata({
    required this.id,
    required this.name,
    required this.category,
    required this.primaryColor,
    required this.accentColor,
    required this.description,
  });
}
