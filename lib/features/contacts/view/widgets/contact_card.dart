import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_pallete.dart';
import '../../../widgets/avatar_initials.dart';
import '../../model/contact_model.dart';

class ContactCard extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
  });

  List<Color> _avatarColors() {
    final gradients = [
      [const Color(0xff137fec), const Color(0xff4a9ff5)],
      [const Color(0xff10b981), const Color(0xff34d399)],
      [const Color(0xfff59e0b), const Color(0xfffbbf24)],
      [const Color(0xffef4444), const Color(0xfff87171)],
      [const Color(0xff8b5cf6), const Color(0xffa78bfa)],
      [const Color(0xffec4899), const Color(0xfff472b6)],
      [const Color(0xff06b6d4), const Color(0xff22d3ee)],
    ];
    final index = contact.name.isNotEmpty
        ? contact.name.codeUnitAt(0) % gradients.length
        : 0;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = _avatarColors();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? Pallete.surfaceDark : Pallete.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Pallete.borderDark
                : Pallete.borderLight,
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
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: AvatarInitials(
                fullName: contact.name,
                textStyle: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Name + Phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Pallete.textPrimaryDark
                          : Pallete.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    contact.phoneNumber,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark
                          ? Pallete.textSecondaryDark
                          : Pallete.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Favourite indicator
            if (contact.isFavorite)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.star_rounded,
                  color: Pallete.kAmber,
                  size: 20,
                ),
              ),

            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? Pallete.textSecondaryDark
                  : Pallete.textSecondaryLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}