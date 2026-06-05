import '../../../config/constant/app_constants.dart';

class ContactModel {
  final int? id;
  final String name;
  final String phoneNumber;
  final String email;
  final bool isFavorite;
  final DateTime createdAt;

  const ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isFavorite = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.colId: id,
      AppConstants.colName: name,
      AppConstants.colPhone: phoneNumber,
      AppConstants.colEmail: email,
      AppConstants.colIsFavorite: isFavorite ? 1 : 0,
      AppConstants.colCreatedAt: createdAt.toIso8601String(),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map[AppConstants.colId] as int?,
      name: map[AppConstants.colName] as String,
      phoneNumber: map[AppConstants.colPhone] as String,
      email: map[AppConstants.colEmail] as String,
      isFavorite: (map[AppConstants.colIsFavorite] as int) == 1,
      createdAt: DateTime.parse(map[AppConstants.colCreatedAt] as String),
    );
  }

  ContactModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, name: $name, phone: $phoneNumber, '
        'email: $email, isFavorite: $isFavorite)';
  }
}