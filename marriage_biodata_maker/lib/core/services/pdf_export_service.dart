import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService();
});

class PdfExportService {
  Future<File> savePdfToLocalDirectory(Uint8List pdfBytes) async {
    final outputDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${outputDir.path}/Marriage_Biodata_$timestamp.pdf');
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  Future<void> sharePdf(Uint8List pdfBytes) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    if (kIsWeb) {
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'Marriage_Biodata_$timestamp.pdf',
      );
      return;
    }
    final file = await savePdfToLocalDirectory(pdfBytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'Marriage Biodata',
    );
  }

  Future<void> printOrSavePdf(Uint8List pdfBytes) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await Printing.layoutPdf(
      onLayout: (_) async => pdfBytes,
      name: 'Marriage_Biodata_$timestamp.pdf',
    );
  }
}
