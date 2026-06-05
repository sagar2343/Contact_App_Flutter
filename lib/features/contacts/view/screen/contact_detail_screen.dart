import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/app_pallete.dart';
import '../../../widgets/animated_screen_wrapper.dart';
import '../../controller/contact_detail_controller.dart';
import '../../model/contact_model.dart';

class ContactDetailScreen extends StatefulWidget {
  final ContactModel contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late final ContactDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ContactDetailController(
      context: context,
      reloadData: () => setState(() {}),
      initialContact: widget.contact,
    );
    _controller.init();
  }

  List<Color> _avatarColors(String name) {
    final gradients = [
      [const Color(0xff137fec), const Color(0xff4a9ff5)],
      [const Color(0xff10b981), const Color(0xff34d399)],
      [const Color(0xfff59e0b), const Color(0xfffbbf24)],
      [const Color(0xffef4444), const Color(0xfff87171)],
      [const Color(0xff8b5cf6), const Color(0xffa78bfa)],
      [const Color(0xffec4899), const Color(0xfff472b6)],
      [const Color(0xff06b6d4), const Color(0xff22d3ee)],
    ];
    final index =
    name.isNotEmpty ? name.codeUnitAt(0) % gradients.length : 0;
    return gradients[index];
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contact = _controller.contact;
    final colors = _avatarColors(contact.name);

    return AnimatedScreenWrapper(
      child: Scaffold(
        backgroundColor:
        isDark ? Pallete.backgroundDark : Pallete.backgroundLight,

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              tooltip: contact.isFavorite
                  ? 'Remove from Favourites'
                  : 'Add to Favourites',
              icon: Icon(
                contact.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: contact.isFavorite
                    ? Pallete.kAmber
                    : (isDark
                    ? Pallete.textSecondaryDark
                    : Pallete.textSecondaryLight),
              ),
              onPressed: _controller.onToggleFavorite,
            ),

            IconButton(
              tooltip: 'Edit Contact',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _controller.onEditContact,
            ),

            IconButton(
              tooltip: 'Delete Contact',
              icon: const Icon(Icons.delete_outline_rounded,
                  color: Pallete.errorColor),
              onPressed: _controller.onDeleteContact,
            ),

            const SizedBox(width: 4),
          ],
        ),

        body: _controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Hero Avatar
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(contact.name),
                        style: GoogleFonts.inter(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    contact.name,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? Pallete.textPrimaryDark
                          : Pallete.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (contact.isFavorite) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Pallete.kAmber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Favourite',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Pallete.kAmber,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Info Cards
                  _InfoCard(
                    isDark: isDark,
                    icon: Icons.phone_rounded,
                    iconColor: Pallete.primaryColor,
                    label: 'Phone',
                    value: contact.phoneNumber,
                    trailing: IconButton(
                      icon: const Icon(Icons.call_rounded),
                      color: Pallete.primaryColor,
                      onPressed: _controller.onCallContact,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (contact.email.isNotEmpty)
                    _InfoCard(
                      isDark: isDark,
                      icon: Icons.email_rounded,
                      iconColor: Pallete.infoColor,
                      label: 'Email',
                      value: contact.email,
                    ),

                  const SizedBox(height: 32),

                  // Call Button
                  _CallButton(onPressed: _controller.onCallContact),

                  const SizedBox(height: 40),
                ],
              ),
            ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Pallete.surfaceDark : Pallete.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallete.borderDark : Pallete.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Pallete.shadowDark : Pallete.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Pallete.textSecondaryDark
                        : Pallete.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Pallete.textPrimaryDark
                        : Pallete.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),

          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CallButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.call_rounded, color: Colors.white),
        label: Text(
          'Call Contact',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Pallete.successColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}