import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../config/constant/app_constants.dart';

class ContactsDatabase {
  ContactsDatabase._();
  static final ContactsDatabase instance = ContactsDatabase._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, AppConstants.dbName);

    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.contactsTable} (
        ${AppConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colName} TEXT NOT NULL,
        ${AppConstants.colPhone} TEXT NOT NULL,
        ${AppConstants.colEmail} TEXT NOT NULL DEFAULT '',
        ${AppConstants.colIsFavorite} INTEGER NOT NULL DEFAULT 0,
        ${AppConstants.colCreatedAt} TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _db = null;
  }
}