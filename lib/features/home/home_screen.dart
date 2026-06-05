import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme/app_pallete.dart';
import '../contacts/view/screen/contacts_screen.dart';
import '../contacts/view/screen/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    ContactsScreen(),
    FavoritesScreen(),
  ];

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Pallete.surfaceDark : Pallete.surfaceLight,
          border: Border(
            top: BorderSide(
              color: isDark ? Pallete.borderDark : Pallete.borderLight,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Pallete.shadowDark : Pallete.shadowLight,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Pallete.primaryColor,
            unselectedItemColor: isDark
                ? Pallete.textSecondaryDark
                : Pallete.textSecondaryLight,
            selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded),
                activeIcon: Icon(Icons.people_rounded),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border_rounded),
                activeIcon: Icon(Icons.star_rounded),
                label: 'Favourites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
