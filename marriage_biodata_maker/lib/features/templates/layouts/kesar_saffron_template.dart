import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class KesarSaffronTempleTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'kesar_saffron_temple';

  @override
  String get name => 'Vedic Saffron & Marigold';

  @override
  String get category => 'Traditional';

  @override
  Color get primaryColor => const Color(0xFFC2410C);

  @override
  Color get accentColor => const Color(0xFFF59E0B);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final saffron = PdfColor.fromHex('#C2410C');
    final marigold = PdfColor.fromHex('#F59E0B');
    final warmParchment = PdfColor.fromHex('#FFFBEB');

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
              color: warmParchment,
              border: pw.Border.all(color: saffron, width: 4),
            ),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: marigold, width: 2.5),
              ),
              padding: const pw.EdgeInsets.all(4),
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: saffron, width: 0.8),
                ),
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
                      color: saffron,
                      fontFallback: [devanagariBold, devanagariFont],
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 5,
                    ),
                    decoration: pw.BoxDecoration(
                      color: saffron,
                      borderRadius: pw.BorderRadius.circular(20),
                      border: pw.Border.all(color: marigold, width: 1.5),
                    ),
                    child: pw.Text(
                      'VIVAH BIODATA',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 3,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 18),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: doc.sections.isNotEmpty
                          ? _buildSection(doc.sections.first, saffron, marigold)
                          : pw.SizedBox(),
                    ),
                    if (profileImage != null) ...[
                      pw.SizedBox(width: 16),
                      pw.Container(
                        width: 112,
                        height: 142,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: saffron, width: 2.5),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.ClipRRect(
                          horizontalRadius: 6,
                          verticalRadius: 6,
                          child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                        ),
                      ),
                    ],
                  ],
                ),
                for (int i = 1; i < doc.sections.length; i++) ...[
                  pw.SizedBox(height: 14),
                  _buildSection(doc.sections[i], saffron, marigold),
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
    PdfColor saffron,
    PdfColor marigold,
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
            color: marigold,
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
        pw.SizedBox(height: 7),
        ...fieldsToRender.map(
          (field) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
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
                      color: saffron,
                    ),
                  ),
                ),
                pw.Text(':  '),
                pw.Expanded(
                  child: pw.Text(
                    field.value.isEmpty ? '-' : field.value,
                    style: const pw.TextStyle(
                      fontSize: 10.5,
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
