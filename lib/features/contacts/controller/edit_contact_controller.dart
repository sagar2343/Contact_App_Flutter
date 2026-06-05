import 'package:flutter/material.dart';
import '../../../core/utils/helpers.dart';
import '../data/contacts_datasource.dart';
import '../model/contact_model.dart';

class EditContactController {
  final BuildContext context;
  final VoidCallback reloadData;
  final ContactModel contact;

  ContactsDatasource? _datasource;

  bool isSaving = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;

  EditContactController({
    required this.context,
    required this.reloadData,
    required this.contact,
  }) {
    nameController  = TextEditingController(text: contact.name);
    phoneController = TextEditingController(text: contact.phoneNumber);
    emailController = TextEditingController(text: contact.email);
  }

  Future<void> init() async {
    _datasource = await ContactsDatasource.create();
  }

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (digitsOnly.length < 7) return 'Enter a valid phone number';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> updateContact() async {
    if (!formKey.currentState!.validate()) return;

    isSaving = true;
    reloadData();

    final updated = contact.copyWith(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      email: emailController.text.trim(),
    );

    final rowsAffected = await _datasource!.updateContact(updated);

    isSaving = false;
    reloadData();

    if (rowsAffected > 0 && context.mounted) {
      Navigator.of(context).pop(updated);
    } else if (context.mounted) {
      Helpers.showSnackBar(
        context,
        'Failed to update contact. Please try again.',
        type: SnackType.error,
      );
    }
  }
}