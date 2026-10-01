import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../biodata_editor/domain/entities/biodata_document.dart';

abstract class PdfTemplateStrategy {
  String get id;
  String get name;
  String get category; // 'Traditional', 'Modern', 'Elegant'
  Color get primaryColor;
  Color get accentColor;

  Future<Uint8List> generatePdf(BiodataDocument document);
}
