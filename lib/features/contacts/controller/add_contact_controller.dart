import 'package:flutter/material.dart';

import '../../../core/utils/helpers.dart';
import '../data/contacts_datasource.dart';
import '../model/contact_model.dart';

class AddContactController {
  final BuildContext context;
  final VoidCallback reloadData;

  ContactsDatasource? _datasource;

  bool isSaving = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  AddContactController({
    required this.context,
    required this.reloadData,
  });

  Future<void> init() async {
    _datasource = await ContactsDatasource.create();
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  // Validation
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (digitsOnly.length < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // save
  Future<void> saveContact() async {
    if (!formKey.currentState!.validate()) return;

    isSaving = true;
    reloadData();

    final newContact = ContactModel(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
      createdAt: DateTime.now(),
    );

    final id = await _datasource!.insertContact(newContact);

    isSaving = false;
    reloadData();

    if (id != null && context.mounted) {
      Navigator.of(context).pop(true);
    } else if (context.mounted) {
      Helpers.showSnackBar(
        context,
        'Failed to save contact. Please try again.',
        type: SnackType.error,
      );
    }
  }
}