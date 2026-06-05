class AppConstants {
  AppConstants._();

  static const String appName = 'Contacts';

  // ── Database
  static const String dbName = 'contacts.db';
  static const int dbVersion = 1;
  static const String contactsTable = 'contacts';

  // ── Column names
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colPhone = 'phoneNumber';
  static const String colEmail = 'email';
  static const String colIsFavorite = 'isFavorite';
  static const String colCreatedAt = 'createdAt';
}