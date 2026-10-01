import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class TraditionalGoldTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'traditional_gold';

  @override
  String get name => 'Royal Traditional Gold';

  @override
  String get category => 'Traditional';

  @override
  Color get primaryColor => const Color(0xFF7B1FA2);

  @override
  Color get accentColor => const Color(0xFFD4AF37);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final pdfPrimary = PdfColor.fromHex('#7B1FA2');
    final pdfAccentGold = PdfColor.fromHex('#D4AF37');
    final bgCream = PdfColor.fromHex('#FFFDF7');

    // Load Unicode & Devanagari fallback fonts for crisp PDF rendering
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
          margin: const pw.EdgeInsets.all(28),
          theme: pw.ThemeData.withFont(
            base: baseFont,
            bold: boldFont,
            fontFallback: [devanagariFont, devanagariBold],
          ),
          buildBackground: (context) => pw.Container(
            decoration: pw.BoxDecoration(
              color: bgCream,
              border: pw.Border.all(color: pdfAccentGold, width: 3),
            ),
            padding: const pw.EdgeInsets.all(6),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: pdfPrimary, width: 1),
              ),
            ),
          ),
        ),
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(
                  child: pw.Text(
                    doc.headerInvocation,
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: pdfPrimary,
                      fontFallback: [devanagariBold, devanagariFont],
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                    'BIODATA',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 3,
                      color: pdfPrimary,
                    ),
                  ),
                ),
                pw.Divider(color: pdfAccentGold, thickness: 1.5),
                pw.SizedBox(height: 16),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: doc.sections.isNotEmpty
                          ? _buildSection(
                              doc.sections.first,
                              pdfPrimary,
                              pdfAccentGold,
                            )
                          : pw.SizedBox(),
                    ),
                    if (profileImage != null) ...[
                      pw.SizedBox(width: 16),
                      pw.Container(
                        width: 115,
                        height: 145,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: pdfAccentGold,
                            width: 2.5,
                          ),
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.ClipRRect(
                          horizontalRadius: 4,
                          verticalRadius: 4,
                          child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                    ],
                  ],
                ),
                for (int i = 1; i < doc.sections.length; i++) ...[
                  pw.SizedBox(height: 14),
                  _buildSection(doc.sections[i], pdfPrimary, pdfAccentGold),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildSection(
    BiodataSection section,
    PdfColor primaryColor,
    PdfColor accentGold,
  ) {
    final nonEmptyFields =
        section.fields.where((f) => f.value.trim().isNotEmpty).toList();

    final fieldsToRender =
        nonEmptyFields.isNotEmpty ? nonEmptyFields : section.fields;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: pw.BoxDecoration(
            color: primaryColor,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            section.title.toUpperCase(),
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        ...fieldsToRender.map(
          (field) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3.5),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 150,
                  child: pw.Text(
                    field.label,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      color: PdfColors.grey800,
                    ),
                  ),
                ),
                pw.Text(
                  ':  ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Expanded(
                  child: pw.Text(
                    field.value.isEmpty ? '-' : field.value,
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
