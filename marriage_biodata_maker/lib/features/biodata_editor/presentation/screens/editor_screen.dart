import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/biodata_notifier.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/section_card.dart';
import 'preview_screen.dart';

class BiodataEditorScreen extends ConsumerWidget {
  const BiodataEditorScreen({super.key});

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1000,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      ref.read(biodataProvider.notifier).updateProfilePhoto(bytes);
    }
  }

  Future<void> _showAddCustomFieldDialog(
    BuildContext context,
    WidgetRef ref,
    String sectionId,
  ) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Field'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Field Label (e.g., Maternal Uncle, Hobby)',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(biodataProvider.notifier)
                    .addCustomField(sectionId, controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biodata = ref.watch(biodataProvider);
    final notifier = ref.read(biodataProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Marriage Biodata'),
        actions: [
          FilledButton.tonalIcon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PreviewAndExportScreen(),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Preview PDF'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Photo Picker
                Center(
                  child: GestureDetector(
                    onTap: () => _pickPhoto(context, ref),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: biodata.profilePhotoBytes != null
                          ? MemoryImage(biodata.profilePhotoBytes!)
                          : null,
                      child: biodata.profilePhotoBytes == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 28),
                                SizedBox(height: 4),
                                Text(
                                  'Add Photo',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Religious / Cultural Invocation Field
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      initialValue: biodata.headerInvocation,
                      decoration: const InputDecoration(
                        labelText: 'Header Invocation / Heading',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: notifier.updateHeaderInvocation,
                    ),
                  ),
                ),

                // Dynamic Sections & Reorderable Fields
                for (final section in biodata.sections)
                  SectionCardWidget(
                    section: section,
                    onReorder: (oldIdx, newIdx) =>
                        notifier.reorderFields(section.id, oldIdx, newIdx),
                    onAddField: () =>
                        _showAddCustomFieldDialog(context, ref, section.id),
                    onDeleteField: (fieldId) =>
                        notifier.deleteField(section.id, fieldId),
                    onValueChanged: (fieldId, val) =>
                        notifier.updateField(section.id, fieldId, value: val),
                  ),
              ],
            ),
          ),
          const PersistentBannerAdWidget(),
        ],
      ),
    );
  }
}
