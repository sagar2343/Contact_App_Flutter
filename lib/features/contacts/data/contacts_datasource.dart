import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../../config/constant/app_constants.dart';
import '../model/contact_model.dart';
import 'contacts_database.dart';

class ContactsDatasource {
  final Database _db;

  ContactsDatasource._(this._db);

  static Future<ContactsDatasource> create() async {
    final db = await ContactsDatabase.instance.database;
    return ContactsDatasource._(db);
  }

  /// Create
  Future<int?> insertContact(ContactModel contact) async {
    try {
      final id = await _db.insert(
        AppConstants.contactsTable,
        contact.toMap()..remove(AppConstants.colId), // let SQLite assign id
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      debugPrint('ContactsDatasource.insertContact error: $e');
      return null;
    }
  }


  /// Get All Contacts
  Future<List<ContactModel>> getAllContacts() async {
    try {
      final rows = await _db.query(
        AppConstants.contactsTable,
        orderBy: '${AppConstants.colName} ASC',
      );
      return rows.map(ContactModel.fromMap).toList();
    } catch (e) {
      debugPrint('ContactsDatasource.getAllContacts error: $e');
      return [];
    }
  }

  /// Search
  Future<List<ContactModel>> searchContacts(String query) async {
    try {
      final rows = await _db.query(
        AppConstants.contactsTable,
        where: '${AppConstants.colName} LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: '${AppConstants.colName} ASC',
      );
      return rows.map(ContactModel.fromMap).toList();
    } catch (e) {
      debugPrint('ContactsDatasource.searchContacts error: $e');
      return [];
    }
  }

  /// Favorite Contacts
  Future<List<ContactModel>> getFavoriteContacts() async {
    try {
      final rows = await _db.query(
        AppConstants.contactsTable,
        where: '${AppConstants.colIsFavorite} = ?',
        whereArgs: [1],
        orderBy: '${AppConstants.colName} ASC',
      );
      return rows.map(ContactModel.fromMap).toList();
    } catch (e) {
      debugPrint('ContactsDatasource.getFavoriteContacts error: $e');
      return [];
    }
  }

  Future<ContactModel?> getContactById(int id) async {
    try {
      final rows = await _db.query(
        AppConstants.contactsTable,
        where: '${AppConstants.colId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) return null;
      return ContactModel.fromMap(rows.first);
    } catch (e) {
      debugPrint('ContactsDatasource.getContactById error: $e');
      return null;
    }
  }

  /// Updates
  Future<int> updateContact(ContactModel contact) async {
    try {
      return await _db.update(
        AppConstants.contactsTable,
        contact.toMap(),
        where: '${AppConstants.colId} = ?',
        whereArgs: [contact.id],
      );
    } catch (e) {
      debugPrint('ContactsDatasource.updateContact error: $e');
      return 0;
    }
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    try {
      return await _db.update(
        AppConstants.contactsTable,
        {AppConstants.colIsFavorite: isFavorite ? 1 : 0},
        where: '${AppConstants.colId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('ContactsDatasource.toggleFavorite error: $e');
      return 0;
    }
  }

  /// Delete
  Future<int> deleteContact(int id) async {
    try {
      return await _db.delete(
        AppConstants.contactsTable,
        where: '${AppConstants.colId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('ContactsDatasource.deleteContact error: $e');
      return 0;
    }
  }
}