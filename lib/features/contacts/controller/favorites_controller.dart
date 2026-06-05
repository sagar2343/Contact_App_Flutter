import 'package:flutter/material.dart';

import '../../../core/utils/app_page_route.dart';
import '../data/contacts_datasource.dart';
import '../model/contact_model.dart';
import '../view/screen/contact_detail_screen.dart';

class FavoritesController {
  final BuildContext context;
  final VoidCallback reloadData;

  ContactsDatasource? _datasource;

  bool isLoading = false;
  List<ContactModel> favorites = [];

  FavoritesController({
    required this.context,
    required this.reloadData,
  });

  Future<void> init() async {
    _datasource = await ContactsDatasource.create();
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    isLoading = true;
    reloadData();

    favorites = await _datasource!.getFavoriteContacts();

    isLoading = false;
    reloadData();
  }

  Future<void> onRefresh() async {
    await _loadFavorites();
  }

  void onContactTap(ContactModel contact) {
    Navigator.of(context)
        .push(AppPageRoute.slideFade(ContactDetailScreen(contact: contact)))
        .then((_) => _loadFavorites()); // refresh on return
  }
}