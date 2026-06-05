import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/helpers.dart';
import '../data/contacts_datasource.dart';
import '../model/contact_model.dart';
import '../view/screen/add_contact_screen.dart';
import '../view/screen/contact_detail_screen.dart';

class ContactsController {
  final BuildContext context;
  final VoidCallback reloadData;

  ContactsDatasource? _datasource;

  bool isLoading = false;
  List<ContactModel> contacts = [];
  List<ContactModel> _allContacts = [];

  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;

  ContactsController({
    required this.context,
    required this.reloadData,
  });

  Future<void> init() async {
    _datasource = await ContactsDatasource.create();
    await _loadContacts();

    searchController.addListener(_onSearchChanged);
  }

  void dispose() {
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
  }

  Future<void> _loadContacts() async {
    isLoading = true;
    reloadData();

    _allContacts = await _datasource!.getAllContacts();
    contacts = List.from(_allContacts);

    isLoading = false;
    reloadData();
  }

  Future<void> onRefresh() async {
    await _loadContacts();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      _filterContacts(searchController.text.trim());
    });
  }

  void _filterContacts(String query) {
    if (query.isEmpty) {
      contacts = List.from(_allContacts);
    } else {
      contacts = _allContacts
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    reloadData();
  }

  void clearSearch() {
    searchController.clear();
    contacts = List.from(_allContacts);
    reloadData();
  }

  void onContactTap(ContactModel contact) {
    Navigator.of(context)
        .push(AppPageRoute.slideFade(
      ContactDetailScreen(contact: contact),
    ))
        .then((result) {
      if (result == true) {
        Helpers.showSnackBar(
          context,
          'Contact deleted',
          type: SnackType.normal,
        );
      }
      _loadContacts();
    });
  }

  void onAddContact() {
    Navigator.of(context)
        .push(AppPageRoute.slideFade(const AddContactScreen()))
        .then((created) {
      if (created == true) {
        Helpers.showSnackBar(context, 'Contact added!',
            type: SnackType.success);
        _loadContacts();
      }
    });
  }
}