import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../core/services/admob_service.dart';
import '../../../../core/services/pdf_export_service.dart';
import '../../../templates/domain/pdf_template_strategy.dart';
import '../../../templates/domain/template_registry.dart';
import '../providers/biodata_notifier.dart';
import '../widgets/banner_ad_widget.dart';

class PreviewAndExportScreen extends ConsumerStatefulWidget {
  const PreviewAndExportScreen({super.key});

  @override
  ConsumerState<PreviewAndExportScreen> createState() =>
      _PreviewAndExportScreenState();
}

class _PreviewAndExportScreenState
    extends ConsumerState<PreviewAndExportScreen> {
  bool _isExporting = false;

  PdfTemplateStrategy _getSelectedStrategy(String templateId) {
    return availableTemplates.firstWhere(
      (t) => t.id == templateId,
      orElse: () => availableTemplates.first,
    );
  }

  /// Gate PDF Export behind AdMob Rewarded/Interstitial Ad
  void _handleAdGatedExport({required bool shareAfterSave}) {
    final adService = ref.read(adMobServiceProvider);

    adService.showExportGateAd(
      context: context,
      onAdCompleted: () async {
        await _generateAndExportPdf(shareAfterSave: shareAfterSave);
      },
      onAdDismissedWithoutReward: () {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please watch the complete ad to unlock your high-resolution PDF biodata.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }

  Future<void> _generateAndExportPdf({required bool shareAfterSave}) async {
    setState(() => _isExporting = true);
    try {
      final biodata = ref.read(biodataProvider);
      final strategy = _getSelectedStrategy(biodata.selectedTemplateId);
      final exportService = ref.read(pdfExportServiceProvider);

      final pdfBytes = await strategy.generatePdf(biodata);

      if (!mounted) return;

      if (shareAfterSave) {
        await exportService.sharePdf(pdfBytes);
      } else {
        await exportService.printOrSavePdf(pdfBytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final biodata = ref.watch(biodataProvider);
    final selectedStrategy = _getSelectedStrategy(biodata.selectedTemplateId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Biodata Preview'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: availableTemplates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final template = availableTemplates[index];
                final isSelected = template.id == biodata.selectedTemplateId;
                return ChoiceChip(
                  label: Text(template.name),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(biodataProvider.notifier)
                        .selectTemplate(template.id);
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Interactive A4 Live Preview
          Expanded(
            child: PdfPreview(
              maxPageWidth: 700,
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              allowPrinting: false,
              allowSharing: false,
              build: (format) => selectedStrategy.generatePdf(biodata),
            ),
          ),

          // Ad-Gated Export Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isExporting
                        ? null
                        : () => _handleAdGatedExport(shareAfterSave: false),
                    icon: const Icon(Icons.download),
                    label: const Text('Save / Print PDF (Ad)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isExporting
                        ? null
                        : () => _handleAdGatedExport(shareAfterSave: true),
                    icon: _isExporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.share),
                    label: const Text('Share PDF (Watch Ad)'),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Banner Ad
          const PersistentBannerAdWidget(),
        ],
      ),
    );
  }
}
