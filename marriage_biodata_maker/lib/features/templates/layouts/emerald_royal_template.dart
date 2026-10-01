import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class EmeraldNikaahArchTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'emerald_royal';

  @override
  String get name => 'Emerald & Champagne Gold';

  @override
  String get category => 'Traditional';

  @override
  Color get primaryColor => const Color(0xFF064E3B);

  @override
  Color get accentColor => const Color(0xFFD97706);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final emerald = PdfColor.fromHex('#064E3B');
    final gold = PdfColor.fromHex('#D97706');
    final mintCream = PdfColor.fromHex('#F8FAF9');

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
          margin: const pw.EdgeInsets.all(26),
          theme: pw.ThemeData.withFont(
            base: baseFont,
            bold: boldFont,
            fontFallback: [devanagariFont, devanagariBold],
          ),
          buildBackground: (context) => pw.Container(
            decoration: pw.BoxDecoration(
              color: mintCream,
              borderRadius: pw.BorderRadius.circular(14),
              border: pw.Border.all(color: emerald, width: 3.5),
            ),
            padding: const pw.EdgeInsets.all(6),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(color: gold, width: 1.5),
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
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: emerald,
                      borderRadius: pw.BorderRadius.circular(20),
                    ),
                    child: pw.Text(
                      doc.headerInvocation,
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                        fontFallback: [devanagariBold, devanagariFont],
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'MATRIMONIAL BIODATA',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 2.5,
                      color: emerald,
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(width: 60, height: 1.5, color: gold),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                      child: pw.Container(
                        width: 7,
                        height: 7,
                        decoration: pw.BoxDecoration(
                          color: emerald,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                    ),
                    pw.Container(width: 60, height: 1.5, color: gold),
                  ],
                ),
                pw.SizedBox(height: 18),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: doc.sections.isNotEmpty
                          ? _buildSection(doc.sections.first, emerald, gold)
                          : pw.SizedBox(),
                    ),
                    if (profileImage != null) ...[
                      pw.SizedBox(width: 16),
                      pw.Container(
                        width: 110,
                        height: 140,
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(12),
                          border: pw.Border.all(color: gold, width: 2.5),
                        ),
                        child: pw.ClipRRect(
                          horizontalRadius: 10,
                          verticalRadius: 10,
                          child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                    ],
                  ],
                ),
                for (int i = 1; i < doc.sections.length; i++) ...[
                  pw.SizedBox(height: 14),
                  _buildSection(doc.sections[i], emerald, gold),
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
    PdfColor emerald,
    PdfColor gold,
  ) {
    final nonEmptyFields =
        section.fields.where((f) => f.value.trim().isNotEmpty).toList();
    final fieldsToRender =
        nonEmptyFields.isNotEmpty ? nonEmptyFields : section.fields;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Container(
              width: 8,
              height: 8,
              decoration: pw.BoxDecoration(
                color: gold,
                shape: pw.BoxShape.circle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(
              section.title.toUpperCase(),
              style: pw.TextStyle(
                color: emerald,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Divider(color: gold, thickness: 0.8),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        ...fieldsToRender.map(
          (field) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 150,
                  child: pw.Text(
                    field.label,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10.5,
                      color: PdfColors.grey800,
                    ),
                  ),
                ),
                pw.Text(':  '),
                pw.Expanded(
                  child: pw.Text(
                    field.value.isEmpty ? '-' : field.value,
                    style: pw.TextStyle(
                      fontSize: 10.5,
                      color: emerald,
                      fontWeight: pw.FontWeight.bold,
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
