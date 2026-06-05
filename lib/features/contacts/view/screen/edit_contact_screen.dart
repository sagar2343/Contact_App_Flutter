import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../widgets/animated_screen_wrapper.dart';
import '../../../widgets/custom_textfield.dart';
import '../../controller/edit_contact_controller.dart';
import '../../model/contact_model.dart';

class EditContactScreen extends StatefulWidget {
  final ContactModel contact;

  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late final EditContactController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditContactController(
      context: context,
      reloadData: () => setState(() {}),
      contact: widget.contact,
    );
    _controller.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedScreenWrapper(
      child: Scaffold(
        backgroundColor:
        isDark ? Pallete.backgroundDark : Pallete.backgroundLight,

        appBar: AppBar(
          title: Text(
            'Edit Contact',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LiveAvatarPreview(
                    nameController: _controller.nameController,
                  ),

                  const SizedBox(height: 28),

                  // Name
                  CustomTextField(
                    controller: _controller.nameController,
                    label: 'Full Name',
                    hint: 'e.g. Jane Smith',
                    prefixIcon: Icons.person_outline_rounded,
                    textCapitalization: TextCapitalization.words,
                    validator: _controller.validateName,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),

                  const SizedBox(height: 16),

                  // Phone
                  CustomTextField(
                    controller: _controller.phoneController,
                    label: 'Phone Number',
                    hint: 'e.g. +91 98765 43210',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputFormatter:
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d\+\-\(\)\s]')),
                    validator: _controller.validatePhone,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),

                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    controller: _controller.emailController,
                    label: 'Email (Optional)',
                    hint: 'e.g. jane@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: _controller.validateEmail,
                  ),

                  const SizedBox(height: 36),

                  // Update Button
                  _UpdateButton(
                    isSaving: _controller.isSaving,
                    onPressed: _controller.updateContact,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveAvatarPreview extends StatefulWidget {
  final TextEditingController nameController;

  const _LiveAvatarPreview({required this.nameController});

  @override
  State<_LiveAvatarPreview> createState() => _LiveAvatarPreviewState();
}

class _LiveAvatarPreviewState extends State<_LiveAvatarPreview> {
  @override
  void initState() {
    super.initState();
    widget.nameController.addListener(() => setState(() {}));
  }

  String get _initials {
    final name = widget.nameController.text.trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 90,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Pallete.primaryColor, Pallete.primaryLightColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _initials,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const _UpdateButton({required this.isSaving, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isSaving ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Pallete.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isSaving
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Text(
          'Update Contact',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}