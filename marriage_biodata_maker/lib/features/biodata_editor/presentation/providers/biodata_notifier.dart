import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/default_biodata_sections.dart';
import '../../domain/entities/biodata_document.dart';
import '../../domain/entities/biodata_field.dart';

final biodataProvider =
    StateNotifierProvider<BiodataNotifier, BiodataDocument>((ref) {
  return BiodataNotifier();
});

class BiodataNotifier extends StateNotifier<BiodataDocument> {
  BiodataNotifier()
      : super(
          BiodataDocument(
            sections: DefaultBiodataSections.getInitialSections(),
          ),
        );

  void selectTemplate(String templateId) {
    state = state.copyWith(selectedTemplateId: templateId);
  }

  void updateHeaderInvocation(String invocation) {
    state = state.copyWith(headerInvocation: invocation);
  }

  void updateProfilePhoto(Uint8List photoBytes) {
    state = state.copyWith(profilePhotoBytes: photoBytes);
  }

  void addCustomField(String sectionId, String label) {
    state = state.copyWith(
      sections: [
        for (final section in state.sections)
          if (section.id == sectionId)
            section.copyWith(
              fields: [
                ...section.fields,
                BiodataField(label: label, value: '', isCustom: true),
              ],
            )
          else
            section,
      ],
    );
  }

  void updateField(
    String sectionId,
    String fieldId, {
    String? label,
    String? value,
  }) {
    state = state.copyWith(
      sections: [
        for (final section in state.sections)
          if (section.id == sectionId)
            section.copyWith(
              fields: [
                for (final field in section.fields)
                  if (field.id == fieldId)
                    field.copyWith(label: label, value: value)
                  else
                    field,
              ],
            )
          else
            section,
      ],
    );
  }

  void deleteField(String sectionId, String fieldId) {
    state = state.copyWith(
      sections: [
        for (final section in state.sections)
          if (section.id == sectionId)
            section.copyWith(
              fields: section.fields.where((f) => f.id != fieldId).toList(),
            )
          else
            section,
      ],
    );
  }

  void reorderFields(String sectionId, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    state = state.copyWith(
      sections: [
        for (final section in state.sections)
          if (section.id == sectionId)
            () {
              final updatedFields = List<BiodataField>.from(section.fields);
              final item = updatedFields.removeAt(oldIndex);
              updatedFields.insert(newIndex, item);
              return section.copyWith(fields: updatedFields);
            }()
          else
            section,
      ],
    );
  }
}
