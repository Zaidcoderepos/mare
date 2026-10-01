import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class RoyalNavySidebarTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'royal_navy_sidebar';

  @override
  String get name => 'Executive Navy & Gold';

  @override
  String get category => 'Modern';

  @override
  Color get primaryColor => const Color(0xFF0F172A);

  @override
  Color get accentColor => const Color(0xFFEAB308);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final navy = PdfColor.fromHex('#0F172A');
    final gold = PdfColor.fromHex('#CA8A04');
    final lightSlate = PdfColor.fromHex('#F8FAFC');

    final baseFont = await PdfGoogleFonts.poppinsRegular();
    final boldFont = await PdfGoogleFonts.poppinsBold();
    final devanagariFont = await PdfGoogleFonts.notoSansDevanagariRegular();
    final devanagariBold = await PdfGoogleFonts.notoSansDevanagariBold();

    final profileImage = doc.profilePhotoBytes != null
        ? pw.MemoryImage(doc.profilePhotoBytes!)
        : null;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          theme: pw.ThemeData.withFont(
            base: baseFont,
            bold: boldFont,
            fontFallback: [devanagariFont, devanagariBold],
          ),
          buildBackground: (context) => pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: navy, width: 3),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: gold, width: 1.2),
              ),
            ),
          ),
        ),
        build: (context) => [
          // Full-bleed Navy & Gold Header Banner inside Frame
          pw.Container(
            margin: const pw.EdgeInsets.fromLTRB(16, 16, 16, 12),
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: navy,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        doc.headerInvocation,
                        style: pw.TextStyle(
                          fontSize: 11,
                          color: gold,
                          fontFallback: [devanagariBold, devanagariFont],
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'MARRIAGE BIODATA',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 2.5,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Container(width: 80, height: 2, color: gold),
                    ],
                  ),
                ),
                if (profileImage != null)
                  pw.Container(
                    width: 85,
                    height: 85,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      border: pw.Border.all(color: gold, width: 2.5),
                    ),
                    child: pw.ClipOval(
                      child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                    ),
                  ),
              ],
            ),
          ),

          // Content Sections in 2-Column Grid Cards
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: pw.Column(
              children: [
                for (final section in doc.sections) ...[
                  _buildSectionCard(section, navy, gold, lightSlate),
                  pw.SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildSectionCard(
    BiodataSection section,
    PdfColor navy,
    PdfColor gold,
    PdfColor lightSlate,
  ) {
    final nonEmptyFields =
        section.fields.where((f) => f.value.trim().isNotEmpty).toList();
    final fieldsToRender =
        nonEmptyFields.isNotEmpty ? nonEmptyFields : section.fields;

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: lightSlate,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border(
          left: pw.BorderSide(color: gold, width: 3.5),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            section.title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: navy,
              letterSpacing: 1.3,
            ),
          ),
          pw.SizedBox(height: 6),
          ...fieldsToRender.map(
            (f) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 155,
                    child: pw.Text(
                      f.label,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.blueGrey700,
                      ),
                    ),
                  ),
                  pw.Text(':  '),
                  pw.Expanded(
                    child: pw.Text(
                      f.value.isEmpty ? '-' : f.value,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
