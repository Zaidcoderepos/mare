import '../../features/biodata_editor/domain/entities/biodata_field.dart';
import '../../features/biodata_editor/domain/entities/biodata_section.dart';

class DefaultBiodataSections {
  DefaultBiodataSections._();

  static List<BiodataSection> getInitialSections() {
    return [
      BiodataSection(
        title: 'Personal Details',
        fields: [
          BiodataField(label: 'Full Name', value: ''),
          BiodataField(label: 'Date of Birth', value: ''),
          BiodataField(label: 'Height', value: ''),
          BiodataField(label: 'Complexion', value: ''),
          BiodataField(label: 'Blood Group', value: ''),
        ],
      ),
      BiodataSection(
        title: 'Horoscope / Astrology',
        fields: [
          BiodataField(label: 'Rashi (Moon Sign)', value: ''),
          BiodataField(label: 'Nakshatra', value: ''),
          BiodataField(label: 'Gotra', value: ''),
          BiodataField(label: 'Time of Birth', value: ''),
          BiodataField(label: 'Place of Birth', value: ''),
        ],
      ),
      BiodataSection(
        title: 'Education & Career',
        fields: [
          BiodataField(label: 'Highest Qualification', value: ''),
          BiodataField(label: 'Occupation / Designation', value: ''),
          BiodataField(label: 'Organization / Company', value: ''),
          BiodataField(label: 'Annual Income', value: ''),
        ],
      ),
      BiodataSection(
        title: 'Family Background',
        fields: [
          BiodataField(label: "Father's Name", value: ''),
          BiodataField(label: "Father's Occupation", value: ''),
          BiodataField(label: "Mother's Name", value: ''),
          BiodataField(label: "Mother's Occupation", value: ''),
          BiodataField(label: 'Siblings', value: ''),
        ],
      ),
      BiodataSection(
        title: 'Contact Info',
        fields: [
          BiodataField(label: 'Contact Number', value: ''),
          BiodataField(label: 'Email Address', value: ''),
          BiodataField(label: 'Residential Address', value: ''),
        ],
      ),
    ];
  }
}
