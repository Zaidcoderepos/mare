import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../domain/pdf_template_strategy.dart';

class ModernMinimalTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'modern_minimal';

  @override
  String get name => 'Modern Minimalist Slate';

  @override
  String get category => 'Modern';

  @override
  Color get primaryColor => const Color(0xFF1E293B);

  @override
  Color get accentColor => const Color(0xFF0F766E);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final slateColor = PdfColor.fromHex('#1E293B');
    final accentTeal = PdfColor.fromHex('#0F766E');

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
          margin: const pw.EdgeInsets.all(36),
          theme: pw.ThemeData.withFont(
            base: baseFont,
            bold: boldFont,
            fontFallback: [devanagariFont, devanagariBold],
          ),
        ),
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    doc.headerInvocation,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: accentTeal,
                      fontFallback: [devanagariBold, devanagariFont],
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'MARRIAGE BIODATA',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: slateColor,
                    ),
                  ),
                ],
              ),
              if (profileImage != null)
                pw.ClipOval(
                  child: pw.Image(
                    profileImage,
                    width: 90,
                    height: 90,
                    fit: pw.BoxFit.cover,
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Divider(color: accentTeal, thickness: 2),
          pw.SizedBox(height: 12),
          for (final section in doc.sections) ...[
            pw.Text(
              section.title.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: accentTeal,
                letterSpacing: 1.2,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.only(left: 10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColors.grey300, width: 2),
                ),
              ),
              child: pw.Column(
                children: section.fields
                    .map(
                      (f) => pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 3),
                        child: pw.Row(
                          children: [
                            pw.SizedBox(
                              width: 160,
                              child: pw.Text(
                                f.label,
                                style: const pw.TextStyle(
                                  fontSize: 10.5,
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                f.value.isEmpty ? '-' : f.value,
                                style: pw.TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: slateColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            pw.SizedBox(height: 16),
          ],
        ],
      ),
    );
    return pdf.save();
  }
}
