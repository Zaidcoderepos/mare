import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../biodata_editor/domain/entities/biodata_document.dart';
import '../../biodata_editor/domain/entities/biodata_section.dart';
import '../domain/pdf_template_strategy.dart';

class RoyalCrimsonMandalaTemplate implements PdfTemplateStrategy {
  @override
  String get id => 'royal_crimson';

  @override
  String get name => 'Shahi Crimson & Gold';

  @override
  String get category => 'Traditional';

  @override
  Color get primaryColor => const Color(0xFF8B0000);

  @override
  Color get accentColor => const Color(0xFFD4AF37);

  @override
  Future<Uint8List> generatePdf(BiodataDocument doc) async {
    final pdf = pw.Document();
    final crimson = PdfColor.fromHex('#800000');
    final gold = PdfColor.fromHex('#D4AF37');
    final ivory = PdfColor.fromHex('#FFFDF9');

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
          buildBackground: (context) => pw.Stack(
            children: [
              // Outer Triple Ornate Frame
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: ivory,
                  border: pw.Border.all(color: crimson, width: 4),
                ),
                padding: const pw.EdgeInsets.all(5),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: gold, width: 2),
                  ),
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: crimson, width: 1),
                    ),
                  ),
                ),
              ),
              // Ornate Corner Accents
              pw.Positioned(
                top: 10,
                left: 10,
                child: _buildCornerMotif(crimson, gold),
              ),
              pw.Positioned(
                top: 10,
                right: 10,
                child: _buildCornerMotif(crimson, gold),
              ),
              pw.Positioned(
                bottom: 10,
                left: 10,
                child: _buildCornerMotif(crimson, gold),
              ),
              pw.Positioned(
                bottom: 10,
                right: 10,
                child: _buildCornerMotif(crimson, gold),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.all(26),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                //Royal Arch Banner Header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: pw.BoxDecoration(
                    color: crimson,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: gold, width: 1.5),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        doc.headerInvocation,
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: gold,
                          fontFallback: [devanagariBold, devanagariFont],
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'MARRIAGE BIODATA',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 3.5,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 18),

                // First section + Ornate Framed Photo
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: doc.sections.isNotEmpty
                          ? _buildSection(doc.sections.first, crimson, gold)
                          : pw.SizedBox(),
                    ),
                    if (profileImage != null) ...[
                      pw.SizedBox(width: 16),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          color: crimson,
                          border: pw.Border.all(color: gold, width: 2),
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Container(
                          width: 112,
                          height: 142,
                          child: pw.ClipRRect(
                            horizontalRadius: 4,
                            verticalRadius: 4,
                            child: pw.Image(
                              profileImage,
                              fit: pw.BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                for (int i = 1; i < doc.sections.length; i++) ...[
                  pw.SizedBox(height: 14),
                  _buildSection(doc.sections[i], crimson, gold),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildCornerMotif(PdfColor crimson, PdfColor gold) {
    return pw.Container(
      width: 22,
      height: 22,
      decoration: pw.BoxDecoration(
        color: gold,
        border: pw.Border.all(color: crimson, width: 2),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      alignment: pw.Alignment.center,
      child: pw.Container(
        width: 8,
        height: 8,
        decoration: pw.BoxDecoration(
          color: crimson,
          shape: pw.BoxShape.circle,
        ),
      ),
    );
  }

  pw.Widget _buildSection(
    BiodataSection section,
    PdfColor crimson,
    PdfColor gold,
  ) {
    final nonEmptyFields =
        section.fields.where((f) => f.value.trim().isNotEmpty).toList();
    final fieldsToRender =
        nonEmptyFields.isNotEmpty ? nonEmptyFields : section.fields;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#FDF2F2'),
            border: pw.Border(
              left: pw.BorderSide(color: crimson, width: 4),
              bottom: pw.BorderSide(color: gold, width: 1),
            ),
          ),
          child: pw.Text(
            section.title.toUpperCase(),
            style: pw.TextStyle(
              color: crimson,
              fontSize: 11.5,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        ...fieldsToRender.map(
          (field) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3.5, horizontal: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 155,
                  child: pw.Text(
                    field.label,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10.5,
                      color: crimson,
                    ),
                  ),
                ),
                pw.Text(
                  ':  ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: gold,
                  ),
                ),
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
