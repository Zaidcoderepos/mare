import 'dart:typed_data';
import 'biodata_section.dart';

class BiodataDocument {
  final String headerInvocation;
  final Uint8List? profilePhotoBytes;
  final String selectedTemplateId;
  final List<BiodataSection> sections;

  const BiodataDocument({
    this.headerInvocation = '|| श्री गणेशाय नमः ||',
    this.profilePhotoBytes,
    this.selectedTemplateId = 'traditional_gold',
    required this.sections,
  });

  BiodataDocument copyWith({
    String? headerInvocation,
    Uint8List? profilePhotoBytes,
    String? selectedTemplateId,
    List<BiodataSection>? sections,
  }) {
    return BiodataDocument(
      headerInvocation: headerInvocation ?? this.headerInvocation,
      profilePhotoBytes: profilePhotoBytes ?? this.profilePhotoBytes,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      sections: sections ?? this.sections,
    );
  }
}
