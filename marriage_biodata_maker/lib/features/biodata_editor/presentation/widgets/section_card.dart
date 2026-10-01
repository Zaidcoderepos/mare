import 'package:flutter/material.dart';
import '../../domain/entities/biodata_section.dart';

class SectionCardWidget extends StatelessWidget {
  final BiodataSection section;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onAddField;
  final void Function(String fieldId) onDeleteField;
  final void Function(String fieldId, String value) onValueChanged;

  const SectionCardWidget({
    super.key,
    required this.section,
    required this.onReorder,
    required this.onAddField,
    required this.onDeleteField,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: onAddField,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Field'),
                ),
              ],
            ),
            const Divider(),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: section.fields.length,
              onReorder: onReorder,
              itemBuilder: (context, index) {
                final field = section.fields[index];
                return Padding(
                  key: ValueKey(field.id),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.drag_indicator, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: field.value,
                          decoration: InputDecoration(
                            labelText: field.label,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) => onValueChanged(field.id, val),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        tooltip: 'Remove field',
                        onPressed: () => onDeleteField(field.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
