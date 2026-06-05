import 'package:flutter/material.dart';

import '../../../core/utils/app_page_route.dart';
import '../../../core/utils/helpers.dart';
import '../data/contacts_datasource.dart';
import '../model/contact_model.dart';
import '../view/screen/add_contact_screen.dart';
import '../view/screen/edit_contact_screen.dart';

class ContactDetailController {
  final BuildContext context;
  final VoidCallback reloadData;

  ContactsDatasource? _datasource;

  ContactModel contact;
  bool isLoading = false;

  ContactDetailController({
    required this.context,
    required this.reloadData,
    required ContactModel initialContact,
  }) : contact = initialContact;

  Future<void> init() async {
    _datasource = await ContactsDatasource.create();
  }

  Future<void> onCallContact() async {
    await Helpers.makePhoneCall(context, contact.phoneNumber);
  }

  void onEditContact() {
    Navigator.of(context)
        .push(AppPageRoute.slideFade(EditContactScreen(contact: contact)))
        .then((updated) {
      if (updated is ContactModel) {
        contact = updated;
        Helpers.showSnackBar(context, 'Contact updated!',
            type: SnackType.success);
        reloadData();
      }
    });
  }

  Future<void> onDeleteContact() async {
    final confirmed = await _showDeleteDialog();
    if (!confirmed) return;

    isLoading = true;
    reloadData();

    final rows = await _datasource!.deleteContact(contact.id!);

    isLoading = false;

    if (rows > 0 && context.mounted) {
      Navigator.of(context).pop(true);
    } else if (context.mounted) {
      reloadData();
      Helpers.showSnackBar(
        context,
        'Failed to delete contact.',
        type: SnackType.error,
      );
    }
  }

  Future<void> onToggleFavorite() async {
    final newValue = !contact.isFavorite;
    final rows = await _datasource!.toggleFavorite(contact.id!, newValue);

    if (rows > 0) {
      contact = contact.copyWith(isFavorite: newValue);
      reloadData();
      if (context.mounted) {
        Helpers.showSnackBar(
          context,
          newValue ? 'Added to Favorites' : 'Removed from Favorites',
          type: SnackType.success,
        );
      }
    }
  }

  // Helper
  Future<bool> _showDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete "${contact.name}"? '
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}