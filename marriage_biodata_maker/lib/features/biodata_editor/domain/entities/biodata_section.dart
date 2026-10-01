import 'package:uuid/uuid.dart';
import 'biodata_field.dart';

const _uuid = Uuid();

class BiodataSection {
  final String id;
  final String title;
  final List<BiodataField> fields;

  BiodataSection({
    String? id,
    required this.title,
    required this.fields,
  }) : id = id ?? _uuid.v4();

  BiodataSection copyWith({String? title, List<BiodataField>? fields}) {
    return BiodataSection(
      id: id,
      title: title ?? this.title,
      fields: fields ?? this.fields,
    );
  }
}
