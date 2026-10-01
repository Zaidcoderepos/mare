import '../../../../core/constants/default_biodata_sections.dart';
import '../../domain/entities/biodata_document.dart';

class LocalStorageRepository {
  BiodataDocument loadInitialDocument() {
    return BiodataDocument(
      sections: DefaultBiodataSections.getInitialSections(),
    );
  }
}
