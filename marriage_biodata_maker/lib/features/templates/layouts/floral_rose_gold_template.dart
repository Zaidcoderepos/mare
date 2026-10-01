import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class FloralRoseGoldTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'floral_rose_gold';

  @override
  String get name => 'Blush Rose Gold Frame';

  @override
  String get category => 'Elegant';

  @override
  Color get primaryColor => const Color(0xFF9D174D);

  @override
  Color get accentColor => const Color(0xFFF472B6);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final roseWine = PdfColor.fromHex('#9D174D');
    final roseGold = PdfColor.fromHex('#E11D48');
    final softBlush = PdfColor.fromHex('#FFF5F7');
    final cardWhite = PdfColor.fromHex('#FFFFFF');

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
              color: softBlush,
              border: pw.Border.all(color: roseWine, width: 2),
            ),
            padding: const pw.EdgeInsets.all(10),
            child: pw.Container(
              decoration: pw.BoxDecoration(
                color: cardWhite,
                borderRadius: pw.BorderRadius.circular(16),
                border: pw.Border.all(
                  color: PdfColor.fromHex('#FBCFE8'),
                  width: 2.5,
                ),
              ),
            ),
          ),
        ),
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.all(28),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(
                  child: pw.Text(
                    doc.headerInvocation,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: roseWine,
                      fontFallback: [devanagariBold, devanagariFont],
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Center(
                  child: pw.Text(
                    'BIODATA',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 4,
                      color: roseWine,
                    ),
                  ),
                ),
                pw.SizedBox(height: 12),
                if (profileImage != null) ...[
                  pw.Center(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: roseGold, width: 2),
                      ),
                      child: pw.ClipOval(
                        child: pw.Image(
                          profileImage,
                          width: 96,
                          height: 96,
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 14),
                ],
                for (final section in doc.sections) ...[
                  _buildSection(section, roseWine, softBlush),
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

  pw.Widget _buildSection(
    BiodataSection section,
    PdfColor roseWine,
    PdfColor softBlush,
  ) {
    final nonEmptyFields =
        section.fields.where((f) => f.value.trim().isNotEmpty).toList();
    final fieldsToRender =
        nonEmptyFields.isNotEmpty ? nonEmptyFields : section.fields;

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: softBlush,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColor.fromHex('#FCE7F3'), width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            section.title.toUpperCase(),
            style: pw.TextStyle(
              color: roseWine,
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
          pw.Divider(color: PdfColor.fromHex('#F9A8D4'), thickness: 0.8),
          ...fieldsToRender.map(
            (field) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 150,
                    child: pw.Text(
                      field.label,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                  pw.Text(':  '),
                  pw.Expanded(
                    child: pw.Text(
                      field.value.isEmpty ? '-' : field.value,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.black,
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
