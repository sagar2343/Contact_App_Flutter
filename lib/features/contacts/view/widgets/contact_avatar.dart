import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/theme/app_pallete.dart';

class ContactAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final double fontSize;

  const ContactAvatar({
    super.key,
    required this.name,
    this.radius = 24,
    this.fontSize = 16,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  Color get _avatarColor {
    final colors = [
      const Color(0xff137fec),
      const Color(0xff10b981),
      const Color(0xfff59e0b),
      const Color(0xffef4444),
      const Color(0xff8b5cf6),
      const Color(0xffec4899),
      const Color(0xff06b6d4),
      const Color(0xffF97316),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _avatarColor,
      child: Text(
        _initials,
        style: GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}