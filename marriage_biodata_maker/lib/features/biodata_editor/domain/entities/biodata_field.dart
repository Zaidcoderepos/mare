import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class BiodataField {
  final String id;
  final String label;
  final String value;
  final bool isCustom;

  BiodataField({
    String? id,
    required this.label,
    required this.value,
    this.isCustom = false,
  }) : id = id ?? _uuid.v4();

  BiodataField copyWith({String? label, String? value}) {
    return BiodataField(
      id: id,
      label: label ?? this.label,
      value: value ?? this.value,
      isCustom: isCustom,
    );
  }
}
