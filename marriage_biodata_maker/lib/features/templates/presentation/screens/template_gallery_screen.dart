import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../biodata_editor/presentation/providers/biodata_notifier.dart';
import '../../../biodata_editor/presentation/screens/editor_screen.dart';
import '../../../biodata_editor/presentation/widgets/banner_ad_widget.dart';
import '../../domain/pdf_template_strategy.dart';
import '../../domain/template_registry.dart';

class TemplateGalleryScreen extends ConsumerStatefulWidget {
  const TemplateGalleryScreen({super.key});

  @override
  ConsumerState<TemplateGalleryScreen> createState() =>
      _TemplateGalleryScreenState();
}

class _TemplateGalleryScreenState extends ConsumerState<TemplateGalleryScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Traditional',
    'Elegant',
    'Modern',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _selectedCategory == 'All'
        ? availableTemplates
        : availableTemplates
            .where((t) => t.category == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marriage Biodata Maker'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (_) {
                    setState(() => _selectedCategory = category);
                  },
                );
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredTemplates.length,
              itemBuilder: (context, index) {
                final template = filteredTemplates[index];
                return GestureDetector(
                  onTap: () {
                    ref
                        .read(biodataProvider.notifier)
                        .selectTemplate(template.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BiodataEditorScreen(),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Visual A4 Frame Thumbnail Preview
                        Expanded(
                          child: _TemplateFramePreview(template: template),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: template.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    template.category,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const PersistentBannerAdWidget(),
        ],
      ),
    );
  }
}

class _TemplateFramePreview extends StatelessWidget {
  final PdfTemplateStrategy template;

  const _TemplateFramePreview({required this.template});

  @override
  Widget build(BuildContext context) {
    final isRose = template.id == 'floral_rose_gold';
    final isNavy = template.id == 'royal_navy_sidebar';
    final isCrimson = template.id == 'royal_crimson';

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isRose
            ? const Color(0xFFFFF5F7)
            : const Color(0xFFFFFDF7),
        border: Border.all(
          color: template.primaryColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(isRose ? 12 : 6),
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: template.accentColor,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(isRose ? 9 : 4),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header style per template
            if (isNavy || isCrimson)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: template.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BIODATA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              )
            else ...[
              Center(
                child: Text(
                  'BIODATA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: template.primaryColor,
                  ),
                ),
              ),
              Divider(color: template.accentColor, thickness: 1),
            ],
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 9,
                        width: 55,
                        decoration: BoxDecoration(
                          color: template.primaryColor.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 5,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 5,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 28,
                  height: 34,
                  decoration: BoxDecoration(
                    color: template.accentColor.withValues(alpha: 0.2),
                    border: Border.all(color: template.accentColor, width: 1.2),
                    borderRadius: BorderRadius.circular(isRose ? 20 : 4),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: template.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 9,
              width: 65,
              decoration: BoxDecoration(
                color: template.accentColor.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 5),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  height: 5,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
